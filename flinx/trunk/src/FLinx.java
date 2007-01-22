import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.sql.*;
import java.util.*;

import javax.swing.*;
import javax.swing.table.AbstractTableModel;


public class FLinx extends JFrame
{
	static final long serialVersionUID = 1;
	
	// resources
	static ResourceBundle res;
	static final String labelSuffix = "Label";
	static final String imageSuffix = "Image";
	static final String actionSuffix = "Action";
	static final String accelSuffix = "Accel";
	static final String sizeSuffix = "Size";
	
	// Database
	static boolean connected = false;
	static final String fdbDefFile = "./flinx.fdb";
	static final String fdbURL = "jdbc:firebirdsql://localhost/";	// only local url :)
	static final String fdbUser = "sysdba";
	static final String fdbPassword = "masterkey";
	static final String fdbDriverName = "org.firebirdsql.jdbc.FBDriver";
	
	// Queries
	static final String sqlShowAll = "select * from links";
	static final String sqlAddLink = "insert into links(id) values (?)";
	static final String sqlDelLink = "delete from links where id = ?";
	static final String sqlGenID = "select gen_id(gen_links_id, 1) from rdb$database";
	
	// actions names
	static final String anOpenDataBase = "open-database";
	static final String anExit = "exit";
	static final String anAutocommit = "autocommit";
	static final String anCommit = "commit";
	static final String anRollBack = "rollback";
	static final String anAdd = "add";
	static final String anDelete = "delete";
	static final String anFind = "find";
	static final String anShowAll = "showall";
	static final String anLookFor = "look-for";
	static final String anLookForTitle = "look-for-title";
	static final String anLookForURL = "look-for-url";
	static final String anLookForDescription = "look-for-description";
	static final String anFollowLink = "follow-link"; 

	static
	{
		try
		{
			res = ResourceBundle.getBundle("res.FLinx",Locale.getDefault());
		}
		catch (MissingResourceException mre)
		{
			System.out.println("res/FLinx.properties not found!?");
			System.exit(1);
		}
    } 
	
	////////////////////////////////////
	// entry point
	////////////////////////////////////
	public static void main(String[] args)
	{	
		// set look & feel
		try
		{
			Integer lf = new Integer(res.getString("lfUseSystem"));
			if (lf.intValue() == 1)
				UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		}
		catch (Exception e) {}
		
		// ok, let's go!
		frameMain = new FLinx();
	}
	
	////////////////////////////////////
	// def constructor
	////////////////////////////////////
	public FLinx()
	{
		// init frame
		/////////////
		
		// event windowClosing
		addWindowListener(
			new WindowAdapter()
			{
				public void windowClosing(WindowEvent e)
				{
					System.exit(0);
				}
			}
		);
		
		// set default size & position
		Integer fWidth = new Integer(res.getString("mfWidth"));
		Integer fHeight = new Integer(res.getString("mfHeight"));
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		setBounds((screenSize.width - fWidth.intValue()) / 2,
				  (screenSize.height - fHeight.intValue()) / 2,
				  fWidth.intValue(),
				  fHeight.intValue());
		
		// set icon
		setIconImage(new ImageIcon(getClass().getResource(res.getString("mfIcon"))).getImage());
		
		// set title		
		setTitle(res.getString("mfTitle"));
		
		// set menu
		setJMenuBar(createMenubar("menubar"));
		
		// set toolbars
		JPanel p = new JPanel();
		p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
		p.add(createToolBar("tbMain"));
		p.add(createToolBar("tbSearch"));		
		Container cp = getContentPane();
		cp.add("North", p);
		
		// set table
		uieTable = new JTable();
		uieTable.setBackground(Color.WHITE);
		uieTable.setGridColor(Color.LIGHT_GRAY);
		uieTable.setRowHeight(20);
		uieTable.setShowVerticalLines(false);
		cp.add("Center", new JScrollPane(uieTable));
		
		// set status bar
		lblStatus = new JLabel();
		cp.add("South", lblStatus);
		
		// create & init popup menu 'look for...'
		pmLookFor = createPopupMenu("popupmenuLookFor");
		for (int i=0; i < pmLookFor.getComponentCount(); i++)
			if (pmLookFor.getComponent(i).getClass() == JCheckBoxMenuItem.class)
				((JCheckBoxMenuItem)pmLookFor.getComponent(i)).setState(true);
		
		// try to connect
		connect(new File(fdbDefFile));
		
		// switch interface
		switchInterface();
		
		// show frame
		setVisible(true);
	}
	
	void connect(File f)
	{
		if (!f.exists())
			return;
		if (jdbc.connect(fdbURL + f.getAbsolutePath(),
				 		 fdbDriverName,
				 		 fdbUser,
				 		 fdbPassword))
		{
			connected = true;
			jdbc.executeQuery(sqlShowAll);
      		uieTable.setModel(jdbc);
			//((JMenuItem)uieMenu.get(anShowAll)).doClick();
			setTitle(f.getName() + " - " + res.getString("mfTitle"));
		}
	}
	
	////////////////////////////////////
	// menu creation
	////////////////////////////////////
	JMenuBar createMenubar(String propName)
	{
		JMenuBar mb = new JMenuBar();
		String[] menuKeys = tokenize(res.getString(propName));
		for (int i = 0; i < menuKeys.length; i++)
		{
		    JMenu m = createMenu(menuKeys[i]);
		    if (m != null)
		    	mb.add(m);
		}
		return mb;
	}
	
	JMenu createMenu(String key)
	{
		String[] itemKeys = tokenize(res.getString(key));
		JMenu menu = new JMenu(res.getString(key + labelSuffix));
		for (int i = 0; i < itemKeys.length; i++)
		{
		    if (itemKeys[i].equals("-"))
		    	menu.addSeparator();
		    else
		    	menu.add(createMenuItem(itemKeys[i]));
		}
		return menu;
	}
	
	JMenuItem createMenuItem(String cmd)
	{
		String key = new String(cmd);
		JMenuItem mi;
		
		if (key.startsWith("+"))
		{
			key = key.substring(1);
			mi = new JCheckBoxMenuItem(res.getString(key + labelSuffix));
		}
		else
			mi = new JMenuItem(res.getString(key + labelSuffix));
		
		mi.setHorizontalTextPosition(JButton.RIGHT);
		mi.setIcon(new ImageIcon(getClass().getResource(res.getString(key + imageSuffix))));
		mi.setActionCommand(res.getString(key + actionSuffix));
		mi.addActionListener(mial);
		mi.setAccelerator(KeyStroke.getKeyStroke(res.getString(key + accelSuffix)));		
		uieMenu.put(key, mi);
		
		return mi;
	}
	
	JPopupMenu createPopupMenu(String key)
	{
		String[] itemKeys = tokenize(res.getString(key));
		JPopupMenu menu = new JPopupMenu();
		for (int i = 0; i < itemKeys.length; i++)
	    	menu.add(createPopupMenuItem(itemKeys[i]));
		return menu;
	}
	
	JMenuItem createPopupMenuItem(String cmd)
	{
		String key = new String(cmd);
		JMenuItem mi;
		
		if (key.startsWith("+"))
		{
			key = key.substring(1);
			mi = new JCheckBoxMenuItem(res.getString(key + labelSuffix));
		}
		else  // isn't used - it's just for future...
		{
			mi = new JMenuItem(res.getString(key + labelSuffix));
			mi.setActionCommand(res.getString(key + actionSuffix));
			mi.addActionListener(mial);
		}
		
		return mi;
	}
	
	String[] tokenize(String input)
	{
		Vector v = new Vector();
		StringTokenizer t = new StringTokenizer(input);
		String cmd[];
		
		while (t.hasMoreTokens())
		    v.addElement(t.nextToken());
		cmd = new String[v.size()];
		for (int i = 0; i < cmd.length; i++)
		    cmd[i] = (String) v.elementAt(i);

		return cmd;
	}
	
	////////////////////////////////////
	// toolbar creation
	////////////////////////////////////
	Component createToolBar(String propName)
	{
		JToolBar tb = new JToolBar();
		
		String[] toolKeys = tokenize(res.getString(propName));
		
		for (int i = 0; i < toolKeys.length; i++)
		{
		    if (toolKeys[i].startsWith("-"))
		    	tb.add(Box.createHorizontalStrut(
		    			new Integer(res.getString(toolKeys[i].substring(1) + sizeSuffix)).intValue()));
		    else if (toolKeys[i].startsWith("@"))
		    	tb.add(new JLabel(res.getString(toolKeys[i].substring(1) + labelSuffix)));
		    else if (toolKeys[i].startsWith("+"))
		    {
		    	JCheckBox cb = new JCheckBox(res.getString(toolKeys[i].substring(1) + labelSuffix));
		    	String an = res.getString(toolKeys[i].substring(1) + actionSuffix);
		    	cb.setActionCommand(an);
		    	cb.addActionListener(mial);
		    	tb.add(cb);
		    	uieCheckBox.put(an, cb);
		    }
		    else if (toolKeys[i].startsWith("#"))
		    {
		    	JTextField tf = new JTextField(30);
		    	tf.addActionListener(new TFAL(res.getString(toolKeys[i].substring(1) + actionSuffix), uieMenu));
		    	tb.add(tf);
		    	uieEdit.put(toolKeys[i].substring(1), tf);
		    }
		    else
		    {
		    	JButton b = new JButton(new ImageIcon(getClass().getResource(res.getString(toolKeys[i] + imageSuffix))));
		    	b.setActionCommand(res.getString(toolKeys[i] + actionSuffix));
			    b.addActionListener(mial);
			    b.setToolTipText(res.getString(toolKeys[i] + labelSuffix));
		    	tb.add(b);
		    	uieTool.put(res.getString(toolKeys[i] + actionSuffix), b);
		    }
		}
		
		tb.add(Box.createHorizontalGlue());
		tb.setName(res.getString(propName + labelSuffix));
		
		return tb;
	}
	
	// main frame
	static FLinx frameMain;
	
	// connector
	JDBC jdbc = new JDBC();
	
	// UI control elements
	HashMap uieMenu = new HashMap();
	HashMap uieTool = new HashMap();
	HashMap uieEdit = new HashMap();
	HashMap uieCheckBox = new HashMap();
	
	// status bar
	JLabel lblStatus;
	
	// menu 'look for...'
	JPopupMenu pmLookFor;
	
	// table
	JTable uieTable;
	
	////////////////////////////////////
	// menuitem ActionListener
	////////////////////////////////////
	MIAL mial = new MIAL();
	class MIAL implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{
			String cmd = ((AbstractButton)e.getSource()).getActionCommand();
	      	if (cmd.equals(anExit))
	      	{
	      		System.exit(0);
	      	}
	      	else if (cmd.equals(anShowAll))
	      	{
	      		jdbc.executeQuery(sqlShowAll);
	      		uieTable.setModel(jdbc);
	      	}
	      	else if (cmd.equals(anAutocommit))
	      	{
	      		jdbc.autoCommit = ((JCheckBoxMenuItem)uieMenu.get(anAutocommit)).getState();
	      		
	      		if (e.getSource().getClass() != JCheckBoxMenuItem.class)
	      		{
	      			jdbc.autoCommit = !jdbc.autoCommit;
	      			((JCheckBoxMenuItem)uieMenu.get(anAutocommit)).setState(jdbc.autoCommit);
	      		}
	      			
	      		ImageIcon img = new ImageIcon(getClass().getResource(res.getString(
	      				anAutocommit + (jdbc.autoCommit ? "_on_" : "") + imageSuffix )));
	      		((JButton)uieTool.get(anAutocommit)).setIcon(img);
	      		((JMenuItem)uieMenu.get(anAutocommit)).setIcon(img);
	      	}
	      	else if (cmd.equals(anCommit))
	      	{
	      		jdbc.commit();
	      		jdbc.executeQuery(sqlShowAll);
	      		uieTable.setModel(jdbc);
	      		//((JMenuItem)uieMenu.get(anShowAll)).doClick();
	      	}
	      	else if (cmd.equals(anRollBack))
	      	{	      	
	      		jdbc.rollback();
	      		jdbc.executeQuery(sqlShowAll);
	      		uieTable.setModel(jdbc);
	      		//((JMenuItem)uieMenu.get(anShowAll)).doClick();  
	      	}
	      	else if (cmd.equals(anAdd))
	      	{
	      		jdbc.addRow();
	      	}
	      	else if (cmd.equals(anDelete))
	      	{
	      		int[] rid = uieTable.getSelectedRows();
	      		for (int i=rid.length-1; i >= 0; i--)
	      			jdbc.deleteRow(rid[i]);
	      	}
	      	else if (cmd.equals(anFind))
	      	{
      			String key = ((JTextField)uieEdit.get("findkey")).getText();
      			String q = sqlShowAll + " where ";
      			boolean first = true;
      			if (((JCheckBoxMenuItem)pmLookFor.getComponent(0)).getState())
      			{
      				q += "title like '%" + key + "%' ";
      				first = false;
      			}
      			if (((JCheckBoxMenuItem)pmLookFor.getComponent(1)).getState())
      			{
      				if (first)
      					first = false;
      				else
      					q += " or ";
      				q += "url like '%" + key + "%' ";
      			}
      			if (((JCheckBoxMenuItem)pmLookFor.getComponent(2)).getState())
      			{
      				if (first)      					
      					first = false;
      				else
      					q += " or ";
      				q += "description like '%" + key + "%' ";
      			}
      			
      			if (!first)
      			{
      				jdbc.executeQuery(q);
      				uieTable.setModel(jdbc);
      			}
	      	}
	      	else if (cmd.equals(anOpenDataBase))
	      	{
	      		JFileChooser fc = new JFileChooser(new File("."));
	      		ExampleFileFilter ff = new ExampleFileFilter();
	      		ff.addExtension("fdb");
	      		ff.addExtension("gdb");
	      		ff.setDescription("database");
	      		fc.setFileFilter(ff);
	      		
	      		int result = fc.showOpenDialog(null);
	      		
	      		if (result == JFileChooser.APPROVE_OPTION)
	      			connect(fc.getSelectedFile());
	      	}
	      	else if (cmd.equals(anLookFor))
	      	{
	      		JButton b = ((JButton)uieTool.get(anLookFor));
	      		Point p = b.getLocationOnScreen();
	      		Dimension d = b.getSize();
	      		Point mp = frameMain.getLocationOnScreen();
	      		pmLookFor.show(frameMain, p.x - mp.x, p.y - mp.y + d.height);
	      	}
	      	else if (cmd.equals(anFollowLink))
	      	{
	      		Runtime r = Runtime.getRuntime();
	      		try
	      		{	
	      			r.exec(res.getString("followlinkCommand") + " " + uieTable.getValueAt(uieTable.getSelectedRow(), 1));
	      		}
	      		catch (IOException ioe)
	      		{}
	      	}
	      	
	      	switchInterface();
	    }
	}
	
	////////////////////////////////////
	// textfields actionListener
	////////////////////////////////////
	class TFAL implements ActionListener
	{
		String cmd;
		HashMap mi;
		public TFAL(String cmd, HashMap mi)
		{
			this.cmd = cmd;
			this.mi = mi;
		}
		public void actionPerformed(ActionEvent e)
		{
			((JMenuItem)mi.get(cmd)).doClick();
		}
	}
	
	////////////////////////////////////
	// interface switcher
	////////////////////////////////////
	void switchInterface()
	{
		// is it effective? :)
		((JMenuItem)uieMenu.get(anAdd)).setEnabled(connected);
		((JButton)uieTool.get(anAdd)).setEnabled(connected);
		((JMenuItem)uieMenu.get(anDelete)).setEnabled(connected);
		((JButton)uieTool.get(anDelete)).setEnabled(connected);
		((JMenuItem)uieMenu.get(anCommit)).setEnabled(connected && jdbc.isChanged());
		((JButton)uieTool.get(anCommit)).setEnabled(connected && jdbc.isChanged());
		((JMenuItem)uieMenu.get(anRollBack)).setEnabled(connected && jdbc.isChanged());
		((JButton)uieTool.get(anRollBack)).setEnabled(connected && jdbc.isChanged());
		((JMenuItem)uieMenu.get(anFind)).setEnabled(connected && !jdbc.isChanged());
		((JButton)uieTool.get(anFind)).setEnabled(connected && !jdbc.isChanged());
		((JMenuItem)uieMenu.get(anShowAll)).setEnabled(connected && !jdbc.isChanged());
		((JButton)uieTool.get(anShowAll)).setEnabled(connected && !jdbc.isChanged());
		
		lblStatus.setText(" Links count: " + jdbc.getRowCount());
	}
	
	////////////////////////////////////
	// JDBC aka JDBCAdapter
	////////////////////////////////////
	class JDBC extends AbstractTableModel
	{
		static final long serialVersionUID = 2;
		
		public boolean autoCommit = false;
		
		Connection connection;
	    Statement statement;
	    ResultSet resultSet;
	    String[] columnNames = {};
	    String[] columnNamesUI = {};
	    Vector rows = new Vector();
	    ResultSetMetaData metaData;
	    
	    ArrayList ids = new ArrayList();
	    ArrayList queries = new ArrayList();
	    
	    public boolean connect(String url, String driverName, String user, String passwd)
	    {
	    	try
	        {
	    		if (connection != null || statement != null)
	                disconnect();
	            Class.forName(driverName);
	            connection = DriverManager.getConnection(url, user, passwd);
	            statement = connection.createStatement();
	        } 
	        catch (ClassNotFoundException ex)
	        {
	            return false;
	        }
	        catch (SQLException ex)
	        {
	        	return false;
	        }
	        
	        return true;
	    }

	    public boolean executeQuery(String query)
	    {
	        if (connection == null || statement == null)
	            return false;
	        try
	        {
	        	resultSet = statement.executeQuery(query);
	            metaData = resultSet.getMetaData();

	            int numberOfColumns =  metaData.getColumnCount();
	            columnNames = new String[numberOfColumns];
	            columnNamesUI = new String[numberOfColumns - 1];
	            for(int column = 0; column < numberOfColumns; column++)
	            {
	                columnNames[column] = metaData.getColumnLabel(column+1);
	                if (column < numberOfColumns - 1)
	                	columnNamesUI[column] = FLinx.res.getString(metaData.getColumnLabel(column+2).toLowerCase() + FLinx.labelSuffix);
	            }

	            rows = new Vector();
	            ids = new ArrayList();
	            while (resultSet.next())
	            {
	                Vector newRow = new Vector();
	                if (getColumnCount() > 0)
	                	ids.add(resultSet.getObject(1));
	                for (int i = 1; i <= getColumnCount(); i++)
	                	newRow.addElement(resultSet.getObject(i+1));
	                rows.addElement(newRow);
	            }
	            fireTableChanged(null);
	        }
	        catch (SQLException ex)
	        {
	            return false;
	        }

	        return true;
	    }

	    public void disconnect() throws SQLException
	    {
	        resultSet.close();
	        statement.close();
	        connection.close();
	    }

	    protected void finalize() throws Throwable
	    {
	        disconnect();
	        super.finalize();
	    }

	    // MetaData

	    public String getColumnName(int column)
	    {
	        if (columnNamesUI[column] != null)
	            return columnNamesUI[column];
	        else
	            return "";
	    }

	    public Class getColumnClass(int column)
	    {
	        int type;
	        try
	        {
	            type = metaData.getColumnType(column+2);
	        }
	        catch (SQLException e)
	        {
	            return super.getColumnClass(column);
	        }

	        switch(type)
	        {
	        case Types.CHAR:
	        case Types.VARCHAR:
	        case Types.LONGVARCHAR:
	            return String.class;

	        case Types.BIT:
	            return Boolean.class;

	        case Types.TINYINT:
	        case Types.SMALLINT:
	        case Types.INTEGER:
	            return Integer.class;

	        case Types.BIGINT:
	            return Long.class;

	        case Types.FLOAT:
	        case Types.DOUBLE:
	            return Double.class;

	        case Types.DATE:
	            return java.sql.Date.class;

	        default:
	            return Object.class;
	        }
	    }

	    public boolean isCellEditable(int row, int column)
	    {
	        try
	        {
	            return metaData.isWritable(column+2);
	        }
	        catch (SQLException e)
	        {
	            return false;
	        }
	    }

	    public int getColumnCount()
	    {
	        return columnNames.length - 1;
	    }

	    // Data methods

	    public int getRowCount()
	    {
	        return rows.size();
	    }

	    public Object getValueAt(int aRow, int aColumn)
	    {
	        Vector row = (Vector)rows.elementAt(aRow);
	        return row.elementAt(aColumn);
	    }

	    public String dbRepresentation(int column, Object value)
	    {
	        int type;

	        if (value == null)
	            return "null";

	        try
	        {
	            type = metaData.getColumnType(column+2);
	        }
	        catch (SQLException e)
	        {
	            return value.toString();
	        }

	        switch(type)
	        {
	        case Types.INTEGER:
	        case Types.DOUBLE:
	        case Types.FLOAT:
	            return value.toString();
	        case Types.BIT:
	            return ((Boolean)value).booleanValue() ? "1" : "0";
	        case Types.DATE:
	            return value.toString(); // This will need some conversion.
	        default:
	            return "'"+value.toString()+"'";
	        }

	    }

	    public void setValueAt(Object value, int row, int column)
	    {
	        try
	        {
	            String query =
	                "update " + metaData.getTableName(column+1) +
	                " set " + columnNames[column+1] + " = " +  dbRepresentation(column, value) +
	                " where ID = " + ids.get(row);
	            if (autoCommit)
	            	executeQuery(query);
	            else
	            	queries.add(query);
	        }
	        catch (SQLException e)
	        {
	            // :)
	        }
	        Vector dataRow = (Vector)rows.elementAt(row);
	        dataRow.setElementAt(value, column);
	        switchInterface();
	    }
	    
	    public void addRow()
	    {
	    	try
	    	{
	    		resultSet = statement.executeQuery(sqlGenID);
	    		resultSet.next();
	    		Integer id = new Integer(resultSet.getInt(1));
	    		ids.add(id);
	    		
	    		PreparedStatement ps = connection.prepareStatement(sqlAddLink);
	    		ps.setInt(1, id.intValue());
	    		
	    		if (autoCommit)
	    			ps.execute();
	    		else
	    			queries.add(ps);
	    	}
	    	catch (SQLException e)
	    	{
	    		// :)
	    	}
	    	Vector newRow = new Vector();
	    	for (int i=0; i < getColumnCount(); i++)
	    		newRow.addElement("");
	    	rows.addElement(newRow);
	    	fireTableChanged(null);
	    }
	    
	    public void deleteRow(int row)
	    {
	    	try
	    	{
	    		PreparedStatement ps = connection.prepareStatement(sqlDelLink);
	    		ps.setInt(1, ((Integer)ids.get(row)).intValue());
	    		
	    		if (autoCommit)
	    			ps.execute();
	    		else
	    			queries.add(ps);
	    	}
	    	catch (SQLException e)
	    	{}
	    	rows.removeElementAt(row);
	    	fireTableChanged(null);
	    }
	    
	    public boolean isChanged()
	    {
	    	return queries.size() > 0 ? true : false;
	    }
	    
	    public void commit()
	    {
	    	for (int i = 0; i < queries.size(); i++)
	    		if (queries.get(i).getClass() == String.class)
	    			executeQuery((String)queries.get(i));
	    		else
	    			try
	    			{
	    				((PreparedStatement)queries.get(i)).execute();
	    			}
	    			catch (SQLException e)
	    			{}
	    	queries = new ArrayList();
	    }
	    
	    public void rollback()
	    {
	    	queries = new ArrayList();
	    }
	}
}
