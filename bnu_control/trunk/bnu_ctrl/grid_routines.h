#pragma once


// common cell's formats
#define	CELL_FMT_LEFT		DT_SINGLELINE|DT_VCENTER|DT_INTERNAL|DT_LEFT
#define	CELL_FMT_CENTER		DT_SINGLELINE|DT_VCENTER|DT_INTERNAL|DT_CENTER
#define	CELL_FMT_RIGHT		DT_SINGLELINE|DT_VCENTER|DT_INTERNAL|DT_RIGHT


// info about top header
struct GRID_TOP_HEADER
{
	int column_width;							// column's width
	char *label;								// text of header for this column, if NULL - label will be not set
	int header_format;							// format of header row only
	int column_format;							// format of other rows of column
};

// label of left header
#define GRID_LEFT_HEADER	char*


// common init function
void grid_init(CGridCtrl *grid,					// pointer to your grid
			   int def_cell_height,
			   int def_cell_width,
			   int row_count,
			   int col_count,
			   int fixed_row_count,
			   int fixed_col_count,
			   bool editable,					// SetEditable(editable), SetFrameFocusCell(editable)
			   bool	selection,					// EnableSelection(selection)
			   GRID_TOP_HEADER th[],			// array of info about each top_header, if NULL - no top header
			   GRID_LEFT_HEADER lh[]);			// array of labels for left header, if NULL - no left header
