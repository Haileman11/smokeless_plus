String formatLifeLost(int totalMinutes) {
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    } else if (totalMinutes < 1440) {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '${hours}h ${minutes}m';
    } else if (totalMinutes < 525600) {
      final days = totalMinutes ~/ 1440;
      final hours = (totalMinutes % 1440) ~/ 60;
      if (days > 365) {
        final years = days ~/ 365;
        final remainingDays = days % 365;
        return '${years}Y ${remainingDays}d ${hours}h';
      } else if (days > 30) {
        final months = days ~/ 30;
        final remainingDays = days % 30;
        return '${months}M ${remainingDays}d ${hours}h';
      } else {
        return '${days}d ${hours}h';
      }
    } else {
      final years = totalMinutes ~/ 525600;
      final remainingMinutes = totalMinutes % 525600;
      final months = remainingMinutes ~/ 43800;
      final days = (remainingMinutes % 43800) ~/ 1440;
      return '${years}Y ${months}M ${days}d';
    }
  }