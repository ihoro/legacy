#include "stdafx.h"
#include "bnu_ctrl.h"


void grid_init(CGridCtrl *grid,
			   int def_cell_height,
			   int def_cell_width,
			   int row_count,
			   int col_count,
			   int fixed_row_count,
			   int fixed_col_count,
			   bool editable,
			   bool	selection,
			   GRID_TOP_HEADER th[],
			   GRID_LEFT_HEADER lh[])
{
	// appearance
	grid->SetDefCellHeight(def_cell_height);
	if (def_cell_width)
		grid->SetDefCellWidth(def_cell_width);
	grid->SetRowCount(row_count);
	grid->SetColumnCount(col_count);
	grid->SetFixedRowCount(fixed_row_count);
	grid->SetFixedColumnCount(fixed_col_count);

	// behaviour
	grid->EnableDragRowMode(false);
	grid->SetEditable(editable);
	grid->EnableSelection(selection);
	grid->SetFixedRowSelection(false);
	grid->SetFixedColumnSelection(false);
	grid->EnableDragAndDrop(false);
	grid->SetRowResize(false);
	grid->SetColumnResize(false);
	grid->SetDoubleBuffering(true);
	grid->SetTrackFocusCell(false);
	grid->SetFrameFocusCell(editable);
	grid->SetHandleTabKey(false);
	grid->EnableTitleTips(false);

	// top header
	if (th)
		for (int i=0; i<col_count; i++)
		{
			grid->SetColumnWidth(i, th[i].column_width);
			if (th[i].label)
				grid->SetItemText(0, i, th[i].label);
			grid->SetItemFormat(0, i, th[i].header_format);
			for (int j=1; j<row_count; j++)
				grid->SetItemFormat(j, i, th[i].column_format);
		}

	// left header
	if (lh)
		for (int j=0; j<row_count; j++)
			if (lh[j])
				grid->SetItemText(j, 0, lh[j]);
}