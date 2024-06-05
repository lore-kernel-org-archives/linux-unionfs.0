Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3541922F6
	for <linux-unionfs@vger.kernel.org>; Wed,  5 Jun 2024 11:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717585521; cv=none; b=A6FivS7Bj+82hGfjmOuqF8bTNyKrMdIaZ6eE0M6v01Bkd/EQ5cFQBaOHiSyPllcQQCnMFUIsmRu4DDe0EEM/EBQ30fSV4khZRGerV/wV/u7xOwTXX1QNLEcbAPZrOe/wKzhaiQlZrEkMTiUYH18U6YfW61rn4qQ6TTfw2N2LSPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717585521; c=relaxed/simple;
	bh=Tj542Ql3NJjfsqzKkHdQSa2YLnrfQwlEirm8q8wFYEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWVKNtARaamykNlLMu409pxa6aoPXqWxxrRyH5yMPYjrnoygBBR4L20nJDLJQBbZxpVaBoh+tn2sAJebTFiwyVOf1eKvPkTxK5fRnXHoAeGZCJe3iRsugKwHa7O2hvCHUBIDYgaik3TI9hniEPMKXnmTORVQM9cGXokYPnObS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=MChRTUQk; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="MChRTUQk"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52ba5868965so1942897e87.2
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Jun 2024 04:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1717585517; x=1718190317; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kyqsMalQEV+9l0Conlo3kxuFIzX2TPTLRyUlJoVzZhE=;
        b=MChRTUQka+ScVsKxC4bU3D1yoCTNQfDwawIb6AYBRwQz9iL8WHyPmSGxmJQhsitdvc
         bkWo+STv54y8dzv4oppwYB2ssbLVP+/JocoEtGz8w0fInsR37s2VAdkkWpbHVLOhGt31
         uqCWbsDVkydO+so9xPJXeT8RdMrEKY+pGZ/AQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717585517; x=1718190317;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kyqsMalQEV+9l0Conlo3kxuFIzX2TPTLRyUlJoVzZhE=;
        b=RX6U17UT8DB2hA+yLT7HDla/URx8G1m9aXxTAyma83+Th9SCnSo8pUq36+FwUQ6UzF
         3q/LXRrPxOp7b/bTp1kVofuNlte9i6jlZBP6mWO4wzF2PQxKEweMgJ+/PbY65Si+GjfJ
         018W/3IRnlHigClug9R1DfekOfK+e6m13sThD5ysdvZiKLUkjrQ6mEjK72m4WD4qzWx5
         5mnbLpXvkqS/3hCf/Kfxb/xJ3Xn/vTVvBOpn8f/XBWLTU325EmntWJP+mKduc2glljnt
         NxCge8HlZ4KPnb/YXPIlTW7uiWhcWQ+L2hU23xjwF0QuXUVRoR0tNxix+UOwhby/ZkYw
         cIsA==
X-Forwarded-Encrypted: i=1; AJvYcCWq7xQD47O3fGJ8uX7EDKiX7RB7B5X7xzlDnUS3k8OptrDYJ4f09GmmBRvujFkU886ncdxj4IV6HhQ7pzqh89BVfLsgCX0xmxmeC79oFA==
X-Gm-Message-State: AOJu0YyOK4x3yBH1gSTynlCOCTMDT5RtzIKpSFNp0LD/HRpHdBMNKY0r
	nOPDt/HYLkhzqm2znTEdFgbo0tDNbed6HzPiuIqUZ4RGomfnVge0Q60wC74mx+1l5MqsmzLD0hW
	Ng8ERsRvUZeVLTF3X5Q9XGvWczcrV7tKkyrG2RN9GS8Y86VtYOyE=
X-Google-Smtp-Source: AGHT+IHF1jsrlJq9KSyXvJxuUgLBjkY9uATcMo/+IhftCPJlKni4Cg/lx7edyCsWko7aivNpEEUAT/3Ib2sKhIAftKg=
X-Received: by 2002:a05:6512:e99:b0:51d:3f07:c93c with SMTP id
 2adb3069b0e04-52bab4b80c7mr1806663e87.3.1717585516840; Wed, 05 Jun 2024
 04:05:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000065b2f6061a14ecde@google.com>
In-Reply-To: <00000000000065b2f6061a14ecde@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 5 Jun 2024 13:05:05 +0200
Message-ID: <CAJfpegveMOTa8jV7fTWARuOU-_xXddrY7G1M3DJeoYNZOJ6hMg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in iter_file_splice_write (4)
To: syzbot <syzbot+5ce16f43e888965f009d@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

#syz dup  possible deadlock in kernfs_seq_start
