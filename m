Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B241F2222B4
	for <linux-unionfs@vger.kernel.org>; Mon,  4 Aug 2025 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754278077; cv=none; b=sR5AAWt/AlEdw8okWma+6rt474WzNEcZPF/1tVSNwSRbsZZMGVfUNiYC+JorvN2foNFMItMkelLtQ5yHZ3WaxH5wIUTfUD6haSw39905IpW8zPpmvfbIttVPSMNe7B61sGPWESBQkWb3uA1TeC6YKLWkPqTkpE2w5ygQWoDcd/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754278077; c=relaxed/simple;
	bh=9wiuP6k1wG6vMLRivsap7gw5iUUkpfLl4UAhoWjCKAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8rS2nPKuyzrC3iNkWS3L8lhTc3sHiNoEsj16xbEQl074wVm/GKPh8Fp593n589cnaUBX/FFlApkSDA7MdZfThr1mViNncxQapClfQGUQrxh4M3kNh2SbVfqGvx5ieOS7QCF94y4wVG3nweWJsptOxiY8J8X93mGQL6cGxvbglQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jtac1voS; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jtac1voS"
Date: Sun, 3 Aug 2025 23:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754278063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H6XbCQgN+3grvKHKvnItYJ561o/BVXTtQhyNXOOC7Nk=;
	b=jtac1voSY7076CoREONk57/0HjrVgWEAwO9TeG+LUmuFcfVQguXeTeazQZmWZwhurEMJoN
	on0Mq97E1A14VNXeE7K09Sv/M6pfP5VHQ5YuA4LULpPg0NhYzFho4Rhhhx3qdHrhkSWegM
	y1ePv4AZI5YzLXmRwGmrN38/DBWSgJs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Huang <mmpgouride@gmail.com>, 
	syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, miklos@szeredi.hu, amir73il@gmail.com, 
	linux-unionfs@vger.kernel.org
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
Message-ID: <xu7rlriapup7s5kbss6q3lb45fgrpjt3t7ef7fidj2ggmu54vf@rl5vw6zbbudh>
References: <67a72070.050a0220.3d72c.0022.GAE@google.com>
 <2F4A26BA-821F-4916-A8F6-71EDBA89A701@gmail.com>
 <20250804032312.GX222315@ZenIV>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804032312.GX222315@ZenIV>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 04, 2025 at 04:23:12AM +0100, Al Viro wrote:
> On Mon, Aug 04, 2025 at 11:02:54AM +0800, Alan Huang wrote:
> > +cc overlayfs
> 
> Sigh...
> 
> 2) what the hell is bch2_symlink() need to lock the new inode for?
> page_symlink() doesn't need that; are there any bcachefs-specific reasons
> to bother with that?

No, there isn't. I'll look it over and kill that tomorrow...
