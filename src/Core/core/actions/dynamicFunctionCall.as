package core.actions
{
	public function dynamicFunctionCall(fct:Function, ...parameters):Boolean
	{
		if (fct != null)
		{
			switch(fct.length)
			{
				case 0:  fct(); break;
				case 1:  fct(parameters[0]); break;
				case 2:  fct(parameters[0], parameters[1]); break;
				case 3:  fct(parameters[0], parameters[1], parameters[2]); break;
				case 4:  fct(parameters[0], parameters[1], parameters[2], parameters[3]); break;
				case 5:  fct(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]); break;
				case 6:  fct(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]); break;
				case 7:  fct(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]); break;
				case 8:  fct(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]); break;
				case 9:  fct(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]); break;
				case 10: fct(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]); break;
				default: throw new Error('no more than 10 parameters supported for dynamicFunctionCall');
			}
			
			return true;
		}
		
		return false;
	}
}