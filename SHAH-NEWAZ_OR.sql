USE [Test]
GO

/****** Object:  StoredProcedure [dbo].[SPGETProductPageingWithOR]    Script Date: 13-Sep-19 12:04:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SPGETProductPageingWithOR]
  @PageNumber int,
  @PageSize int,
  @OrderBy nvarchar(100),
  @Search nvarchar(200)
 -- @debug bit = 0
AS

DECLARE @sql        nvarchar(MAX), 
        @paramlist  nvarchar(4000),
        @nl         char(2) = char(13) + char(10)

SELECT @sql = 'SELECT * from Product WHERE [Name] = @Search OR Description=@Search OR ImageUrl = @Search OR Category=@Search' + @nl


SELECT @sql += ' ORDER BY '+quotename(@OrderBy)+ ' OFFSET (@PageNumber-1) * @PageSize  ROWS FETCH next @PageSize ROWS ONLY' + @nl
--SELECT @sql += ' ORDER BY id' + @nl


  --IF @debug = 1
  -- PRINT @sql


SELECT @paramlist = '@PageNumber int,
					 @PageSize int,
					 @OrderBy nvarchar(100),
                     @Search nvarchar(200)'
					 --@debug bit
                   
EXEC sp_executesql @sql, @paramlist,@PageNumber, @PageSize, @OrderBy,
                   @Search --@debug

GO

