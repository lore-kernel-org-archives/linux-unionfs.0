Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8291DDC1B
	for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2026 23:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825743; cv=none; b=WD2YudrQ3fVxcraSXOQg9bTJ1DFTo9t4MpxE6sVnTMGvkTGu1doHWEBY/aajH2lZTkr534BcFHL0KFWgLzUH7mdnsYFYV9vihnCsNXMG5fHqYTA1csYmKzGdhIh+01iBbNGxAbGTxv8FM4kZnyWhCcAz8WJLa/BbcAgTN5I3wxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825743; c=relaxed/simple;
	bh=lsktn//grkYckJ9Eoj9vBqk4WBGlof5JT6nnzYeedDk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ksNLk0iKJjhvBWHOtNIOB5DxD1ZUGDVlwF72G6DBpo1vupnFWv7DxIm5jeOLu+aexgAZQqq1uJAhVdZbei7QbwP0tCApeoyawbB2m9NIk+/gBKzWg56EdALuAGqmjF2osbXPTiSGV93KKbFkcLl/RWKcz4v3c9ks83R747feN4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pR3nImkb; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pR3nImkb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781825738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lsktn//grkYckJ9Eoj9vBqk4WBGlof5JT6nnzYeedDk=;
	b=pR3nImkbiiXi7BTDPJrWhuxyIV2V1oQ9vm5JGnLnQTSP2NYjz64stYXvtZu5j/TWhHOXW9
	NIBIWvUOPPUvDTQYTBrLAvtZE6xP90PLyZXMAktCKAuC397uH9DerNcBs3fQr/NQ86NI/i
	X2PwAaJ80epH6KRmxRs1AAXwK1H1W0s=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Amir Goldstein <amir73il@gmail.com>
Cc: sashiko@lists.linux.dev,  overlayfs <linux-unionfs@vger.kernel.org>,
  Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: Sashiko reviews for overlayfs
In-Reply-To: <CAOQ4uxiJjVvrAwB4kcSsKsjgjtDyfy-1zDS=sMMt5Ke0ZQRSHA@mail.gmail.com>
	(Amir Goldstein's message of "Thu, 18 Jun 2026 21:11:59 +0200")
References: <CAOQ4uxiJjVvrAwB4kcSsKsjgjtDyfy-1zDS=sMMt5Ke0ZQRSHA@mail.gmail.com>
Date: Thu, 18 Jun 2026 23:34:45 +0000
Message-ID: <7ia4ldcb1kyy.fsf@castle.c.googlers.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Amir Goldstein <amir73il@gmail.com> writes:

> Hi Sashiko,
>
> Please review patches sent to
> linux-unionfs@vger.kernel.org

Hi Amir,

https://sashiko.dev/#/?list=org.kernel.vger.linux-unionfs

Thanks
