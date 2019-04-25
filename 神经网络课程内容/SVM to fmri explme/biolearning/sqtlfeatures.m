function [idx,z] = sqtlfeatures(varargin)
%SQTLFEATURES has been renamed as RANKFEATURES. In version 2.1 of the
%Bioinformatics Toolbox SQTLFEATURES redirects the input arguments to
%RANKFEATURES. After version 2.1 a new algorithm for feature selection 
%will be implemented in SQTLFEATURES. 
%
%   See also RANKFEATURES.

%   Copyright 2003-2005 The MathWorks, Inc.
%   $Revision: 1.1.10.2 $  $Date: 2005/06/09 21:58:17 $

warning('Bioinfo:sqtlfeatures:functionRenamed',...
 ['SQTLFEATURES has been renamed as RANKFEATURES. In version 2.1 of ',...
  'the\n         Bioinformatics Toolbox SQTLFEATURES redirects the ',...
  'input arguments to\n         RANKFEATURES. After version 2.1 a new ',...
  'algorithm for feature selection\n         will be implemented in ',...
  'SQTLFEATURES.'])

[idx,z] = rankfeatures(varargin{:});


