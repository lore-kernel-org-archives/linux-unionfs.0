Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA93CCA11;
	Thu, 19 Mar 2026 13:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773925997; cv=none; b=jiKpZRQ27OrEoIXstWT2EZOiTQXj074F5qVuPchlHLek2qOfOnadz/OB5ZmiL4o3XglxcYyD+a3dvYBrcqLZTn86hy7zpjkUu1iGqCm5CJITpFMq9PsZrM5FpBeME8NwLWJyEPIkhHNCOmqrqKsMsn/g9TVM6sOTakRPSdS/H3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773925997; c=relaxed/simple;
	bh=o0GtjwXsZyAZFpgX3LDrd2FmLVg91cOKEz6WcZioyn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fycPpF6WMEhJcbnR3VMcz6gel1y+ruGDTHzKPfK0yuDxcSG6DbCLAKAepXYa3y1gJII4W5SYMVJzfTFtCi3CTiM8zd0Xsgs4pg7MKGz9e7vs0k8MdFlARqD8Vl1DpncvvXVbgKkO6d80Uq1B1RmLCZL7XoiQIET/OdYYs1nkpII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj9N/NGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj9N/NGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A62C2BC9E;
	Thu, 19 Mar 2026 13:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925995;
	bh=o0GtjwXsZyAZFpgX3LDrd2FmLVg91cOKEz6WcZioyn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yj9N/NGrUHSkSxUHPR5wlrEp09cIUI2NlyADHzuDc7+XVF+gabNTkf6nfPh7iW6GH
	 jRVPjk48eMELakt84A7o+pxeAFDaMSFZ7RS5/Fur6R1urrlorR/wcc8pkTWEn1XB+P
	 Wh/o/O/fokKWwpTjEfPivJ2w4BZDTFMpqP3waU4AYpgK4N4reyPaewH/G+rGR4/ULD
	 FRuUkKaTnq9FpwDXFjs7LjQyVRhFT0+CXTLzmBDW35p3h3LdDjDwdD5vIpTrc6YHNG
	 1cd4FYEISN48Aixb42btL9l4YuK7PWV/Gp8AJwbtbV1VVmFsKpi7hjy0e+uI31cyTN
	 gSvEjnjpjIU/w==
Date: Thu, 19 Mar 2026 14:13:10 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, 
	Paul Moore <paul@paul-moore.com>, Gao Xiang <xiang@kernel.org>, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
Subject: Re: [PATCH] fs: allow vfs code to open an O_PATH file with negative
 dentry
Message-ID: <20260319-unentbehrlich-reitturnier-f78d9fb01230@brauner>
References: <20260319124616.1544415-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260319124616.1544415-1-amir73il@gmail.com>

On Thu, Mar 19, 2026 at 01:46:16PM +0100, Amir Goldstein wrote:
> The fields f_mapping, f_wb_err, f_sb_err are irrelevant for O_PATH file.
> Skip setting them for O_PATH file, so that the O_PATH file could be
> opened with a negative dentry.
> 
> This is not something that a user should be able to do, but vfs code,
> such as ovl_tmpfile() can use this to open a backing O_PATH tmpfile
> before instantiating the dentry.
> 
> Reported-by: syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Christian,
> 
> This patch fixes the syzbot report [1] that the
> backing_file_user_path_file() patch [2] introduces.
> 
> This is not the only possible fix, but it is the cleanest one IMO.
> There is a small risk in introducing a state of an O_PATH file with
> NULL f_inode, but I (and the bots that I asked) did not find any
> obvious risk in this state.
> 
> Note that specifically, the user path inode is accessed via d_inode()
> and not via file_inode(), which makes this safe for file_user_inode()
> callers.
> 
> BTW, I missed this regression with the original patch because I
> only ran the quick overlayfs sanity test.
> 
> Now I ran a full quick fstest cycle and verified that the O_TMPFILE
> test case is covered and that the bug is detected.
> 
> WDYT?
> 
> Thanks,
> Amir.
> 
> [1] https://syzkaller.appspot.com/bug?extid=f34aab278bf5d664e2be
> [2] https://lore.kernel.org/linux-fsdevel/20260318131258.1457101-1-amir73il@gmail.com/
> 
>  fs/open.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 91f1139591abe..2004a8c0d9c97 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -893,9 +893,6 @@ static int do_dentry_open(struct file *f,
>  
>  	path_get(&f->f_path);
>  	f->f_inode = inode;
> -	f->f_mapping = inode->i_mapping;
> -	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
> -	f->f_sb_err = file_sample_sb_err(f);
>  
>  	if (unlikely(f->f_flags & O_PATH)) {
>  		f->f_mode = FMODE_PATH | FMODE_OPENED;
> @@ -904,6 +901,10 @@ static int do_dentry_open(struct file *f,
>  		return 0;
>  	}
>  
> +	f->f_mapping = inode->i_mapping;
> +	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
> +	f->f_sb_err = file_sample_sb_err(f);
> +
>  	if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ) {
>  		i_readcount_inc(inode);
>  	} else if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mode)) {

I think this is really ugly and I'm really unhappy that we should adjust
initialization of generic vfs code for this. My preference is to push
the pain into the backing file stuff. And my ultimate preference is for
this backing file stuff to be removed again for a simple struct path.
We're working around some more fundamental cleanup here imho.
