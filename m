Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339927586C;
	Tue, 19 Aug 2025 11:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755602285; cv=none; b=tOk0VV2GWoa/M3D5Wh/bLRxV0jevXiTkS/UNA9puJGq5cqjkfZnQ1fVYeeA40f9ASB5sH5VaE+9jWzPMV4l4ZuOHJzXHDGCw/IxnESEry3AWajRvCfknKMsGWThr+8TRnU+VvtN+jTig6heSn3T0x2gWnq5sBY730WTCqkTF+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755602285; c=relaxed/simple;
	bh=tCyacOs6t4FdeCZERs7W3rtRUW9u04vzTQU2fmmA/Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxiAVT+fKB39TWwbh1wzP6OKiy/rZuQQoEfuqJB47m34ZWts29HN338hYuozJDgOwLVLzvIOsTMcDh4Bhno2FoNJwZxacjgVhNbHRTk1G1HnR7/zKWypXFe8zITNyiZCp5YGzcS6lF6ah1OpcVrLMMS6KSZoycrxagZ0ZygJZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gb1oXTb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gb1oXTb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643E1C4CEF1;
	Tue, 19 Aug 2025 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755602285;
	bh=tCyacOs6t4FdeCZERs7W3rtRUW9u04vzTQU2fmmA/Uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gb1oXTb9GhMI0ispwmXdk4PXueB03XJmtEmDa1aTc2cUONF/xlG70BF4h82bmOfks
	 xhyPm9LO+LYf17HLXEHh1bYZfy089kt5dMePYJjq89Pa59NUAqScp79FWOqAfup7YH
	 n970p79Y53X9nnzkH2hAVJGcaLY775FAUPj6RChNQ5T1as075K4peFgZA/7X0E1Sho
	 1SNl+pHH/6ZBxU7wW1g/Np0avxvKeKzdDUz82mEZB/TjJDjK0OeazCIVcPUr6+riul
	 EsMLWjS0+6kwKkkQnQjqQNCG25PAK5aKeae3t/r85nVkzOqxzs8o1G/ZSc/jtwJNwz
	 Obnhkv23KPZ8Q==
Date: Tue, 19 Aug 2025 13:18:01 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Sohan Kunkerkar <sohank2602@gmail.com>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] overlayfs: add FS_ALLOW_IDMAP flag to enable idmapped
 mounts
Message-ID: <20250819-neuralgisch-ehren-8926ca85db7a@brauner>
References: <20250815150629.2097562-1-sohank2602@gmail.com>
 <CAOQ4uxjX_YYVvVj7NqwAaX-LMkbTgJwkXY3a=p9F+h6810e9CA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjX_YYVvVj7NqwAaX-LMkbTgJwkXY3a=p9F+h6810e9CA@mail.gmail.com>

On Fri, Aug 15, 2025 at 05:30:09PM +0200, Amir Goldstein wrote:
> On Fri, Aug 15, 2025 at 5:06 PM Sohan Kunkerkar <sohank2602@gmail.com> wrote:
> >
> > OverlayFS already has comprehensive support for idmapped mounts through
> > its ovl_copyattr() function and proper mnt_idmap() handling throughout
> > the codebase. The infrastructure correctly maps UIDs/GIDs from idmapped
> > upper and lower layers.
> >
> > However, the filesystem was missing the FS_ALLOW_IDMAP flag, which
> > caused mount_setattr() calls with MOUNT_ATTR_IDMAP to fail with -EINVAL.
> >
> > This change enables idmapped mount support by adding the FS_ALLOW_IDMAP
> > flag to the overlayfs file_system_type, allowing containers and other
> > applications to use idmapped mounts with overlay filesystems.
> >
> > Signed-off-by: Sohan Kunkerkar <sohank2602@gmail.com>
> > ---
> >  fs/overlayfs/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index e19940d64..c628f9179 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1516,7 +1516,7 @@ struct file_system_type ovl_fs_type = {
> >         .name                   = "overlay",
> >         .init_fs_context        = ovl_init_fs_context,
> >         .parameters             = ovl_parameter_spec,
> > -       .fs_flags               = FS_USERNS_MOUNT,
> > +       .fs_flags               = FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
> >         .kill_sb                = kill_anon_super,
> >  };
> >  MODULE_ALIAS_FS("overlay");
> > --
> > 2.50.1
> 
> So Christian just forgot to do that?
> 
> Somehow I find that hard to believe.
> 
> I am guessing there were either some known issues or
> more code audits that needed to be done.
> 
> Christian? WDYT?

This is very wrong.

For overlayfs supporting idmapped mounts can mean two distinct things:

(1) mounting overlayfs on top of idmapped layers
(2) idmapping overlayfs itself

So far only (1) is supported. In order to support (2) further changes
are required. To support (2) it is necessary to also take idmappings
into account on the overlayfs idmapping layer itself and overlayfs
internally needs to be made aware that it needs to do a double
translation. One for the overlayfs layer itself and then one for the
lower and upper layers.

It is possible as I've written that code years ago but it introduces a
lot more subtle behavior. So only if someone really needs this.
