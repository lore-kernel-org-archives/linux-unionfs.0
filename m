Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83811FB3;
	Mon,  4 Aug 2025 03:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754277799; cv=none; b=edl+ONeseaRpS67c8Pjheo2RnnGVOTGh/HXOEdpFMVOn6wtq4qXOmOrKnA5CEz0aWYVoBVWCAHQDnO6Ls3hZCKmTGau8TlP/T0CKQEsm1XAGV7WaY5B09w3wokvAwuuJTkD7+bX5x1G/w2l99TK2vn8ijQmbuZIefwvpP5JYMv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754277799; c=relaxed/simple;
	bh=rkHrsiltpyorC3JdIlb1s8D1l44/yq7sco9JKsORU8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzU1mEGRF/dGP/BH92wcsruSCohzqs8MLwAelHPaTlZQ44rTy1EYVSBzMF7ouVQpjD+WvsC2lr1KP7igbaAvyeblAXufho93i48NTJXXZJWzyPmEY/W7mO1gjj5ZK2tmb5H/NMNRraNI+e0ElOICHY7u0LbxSXXY/wiS0frO35w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BnrkU7QJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BnrkU7QJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rkHrsiltpyorC3JdIlb1s8D1l44/yq7sco9JKsORU8w=; b=BnrkU7QJRevf9K0bcxD2TMqUgm
	LANvzmptr0416EUlmWmkx05xjNi2B9yAg9K+AFeFLQ/3I/SVx46NVd/CWVo/Yk3HNRvnPYVpVd4zW
	jDgdFwXHmqSW+DIHKQl+GHaHB/6IJvTDTpxoX2zr6giR0QI0KjTiAOy821Nkuy0R7Yp8D6LqM8P8d
	WXuUXfzeAKwAywDeWeBvU+G3bPR2RXjFQLPwBt4lCBtTQecb+8V8nwByjHUis/6b9GwDZmFpUtrqw
	yvtiEyYsVYOn/nOPol3Y0tSsWmwp2uI0C2HCzu+yEodmdL/ooPfq4iQBzbk5eMhkt+Vxc7+va+rsJ
	dVcC9rrQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uiln6-00000006nWu-12W2;
	Mon, 04 Aug 2025 03:23:12 +0000
Date: Mon, 4 Aug 2025 04:23:12 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Alan Huang <mmpgouride@gmail.com>
Cc: syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	miklos@szeredi.hu, amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
Message-ID: <20250804032312.GX222315@ZenIV>
References: <67a72070.050a0220.3d72c.0022.GAE@google.com>
 <2F4A26BA-821F-4916-A8F6-71EDBA89A701@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2F4A26BA-821F-4916-A8F6-71EDBA89A701@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Aug 04, 2025 at 11:02:54AM +0800, Alan Huang wrote:
> +cc overlayfs

Sigh...

1) ovl_copy_up_workdir() should lock wdir with I_MUTEX_PARENT, same
as filename_create().

2) what the hell is bch2_symlink() need to lock the new inode for?
page_symlink() doesn't need that; are there any bcachefs-specific reasons
to bother with that?
