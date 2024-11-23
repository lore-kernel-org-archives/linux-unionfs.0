Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96051C32;
	Sat, 23 Nov 2024 00:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732321323; cv=none; b=oc01N0feBxjgop8+nRKZRSkQVFjMMtPK8jI7BB5llVJeyBPg4s7W7CTyyPwjzicKuSV/t4V0qqsF17KLOqFlYY1TCCXJ/BQUSrOMd9/FwrA6vVBWMuDyeBmAT7JOxKOSZwjYF7AwENlzL1R84+agxdpW1k9FaOAbCfYjDkZk8wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732321323; c=relaxed/simple;
	bh=rkjn49mtC1S94mjUFriAn6TvYzOkrDkIbPq25hOan3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvHa4rtsu0hnLqiG1nubzkSrlJL1kQ1U6l+S0Pr3e0/fvp+evq5ZpJWKeM/W9pajSb76xFMyCJzZGctawAgFr1m8gcSyZDZGgJQVd4d/0vHshPLaHpENzxzIkkJIobmOWycIWY4OSVTSZ0Sm57ETv8pUwsN30W7i6s3n9gWe8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=YKcgaKa1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="YKcgaKa1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BNOSJaD5GgA1fqpqvtfLK0GwIZPOtJDBbgRHTA7xYu0=; b=YKcgaKa1kcb3jKzB4VFmdhMulY
	r/wOnjiJPyRbLhFnUwuDJAGNcvohEFxAyhuxYgxMmqjqCr9fXi4lQgXO03cNLQ7E0D+NpbfBfLx/f
	c15d/WrjPem57Klp4m/boY9lesPwCTHaw0z1mjunfAhiyy/04V0rpAXJPMccDsBrD2iu+O4NfDYkP
	kEHmTp+WQAA8k+D8Vs4jJbIr6Cb2iLYDSCxQvRZNnAqF+b3Vn//Yp+of95A4WQ2NRjJBzFN4m2SdO
	vwAmMmoddBaUHfenAFnkt0BIbZU7wV+K0NiLpbfKNfAsfliTiajqt0gYVBD3kFhXysEYWO1wSfGxj
	8VaUbjtg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tEduP-00000000Ytu-2SnU;
	Sat, 23 Nov 2024 00:21:57 +0000
Date: Sat, 23 Nov 2024 00:21:57 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ovl: Add check for missing lookup operation on inode
Message-ID: <20241123002157.GP3387508@ZenIV>
References: <20241118141703.28510-1-kovalev@altlinux.org>
 <CAOQ4uxjxXHX4j=4PbUFrgDoDYEZ1jkjD1EAFNxf1at44t--gHg@mail.gmail.com>
 <CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com>
 <6fb27fea-3998-0fdf-9210-d7479baf0570@basealt.ru>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fb27fea-3998-0fdf-9210-d7479baf0570@basealt.ru>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Nov 19, 2024 at 05:33:03PM +0300, Vasiliy Kovalev wrote:

> without a lookup operation.  Adding the following check in bfs_iget:
> 
> struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
> {
> 
> ...
> 	brelse(bh);
> 
> +	if (S_ISDIR(inode->i_mode) && !inode->i_op->lookup) {
> +		printf("Directory inode missing lookup %s:%08lx\n",
> 						inode->i_sb->s_id, ino);
> +		goto error;
> +	}
> +
> 	unlock_new_inode(inode);
> 	return inode;
> 
> error:
> 	iget_failed(inode);
> 	return ERR_PTR(-EIO);
> }
> 
> prevents the error but exposes an invalid inode:
> 
> loop0: detected capacity change from 0 to 64
> BFS-fs: bfs_iget(): Directory inode missing lookup loop0:00000002
> overlayfs: overlapping lowerdir path
> 
> Would this be considered a valid workaround, or does BFS require further
> fixes?

Yes, it does.  Note that this
        inode->i_mode = 0x0000FFFF & le32_to_cpu(di->i_mode);
sets the bits 0..15, which includes not only the permissions
(0..11), but the file type as well.  And those |= are not
going to be enough to prevent trouble - what we have there
is
	0x1000 => FIFO
	0x2000 => CHR
	0x4000 => DIR
	0x6000 => BLK
	0x8000 => REG
	0xa000 => LNK
	0xe000 => SOCK

So depending upon ->i_vtype you get one of
	* ->i_op and ->i_fop set for directory, type bits - 0x4000 | junk
	* ->i_op and ->i_fop set for regular file, type bits - 0x8000 | junk
	* ->i_op and ->i_fop left empty, type bits - junk.

Frankly, I would rather ignore bits 12..15 (i.e.
        inode->i_mode = 0x00000FFF & le32_to_cpu(di->i_mode);
instead of
        inode->i_mode = 0x0000FFFF & le32_to_cpu(di->i_mode);
) and complain (and fail) if ->i_vtype value is fucked up.
