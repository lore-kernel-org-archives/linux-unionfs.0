Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998EEB672
	for <linux-unionfs@vger.kernel.org>; Mon,  3 Aug 2026 12:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785758752; cv=none; b=LHa2YTDbwFz8GOztE6I96WaBOffXvVm4/1M7Xd3S9Vrc4mUn6XIUwD2dYDsdUnZS2TkNipB4pyKvZirtjG0aZAqcDXuF/4Ji2pC7bEw0nQ8hq5QN1NrlKVIN1aZ4mLwkd+Iy1Hunag1NmZDqhhAKHonQDic3TbWOTlM1EBPxlzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785758752; c=relaxed/simple;
	bh=nqTzNRCJO3wqJREleUU77/xKkveMfYlnLcF68EY26ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZz2umyURZ/eBgta5/5hV4fZineMDCy/k7CdnQPdTjHbf5mLyniN4iHo4gdTL0xMd6+Z6OPM40xpoQiUf0HFEEueltLoAUF5vnLJXcGHObeW1P8LzbYYloEA72tiJ9DEIR1J0kMjHH5MBSdtGrBBndoRzuxOmz+1NqR/QKPikdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qR6eKlKw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BZAiIMkw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eLdxZkJc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vGVVMShC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qR6eKlKw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BZAiIMkw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eLdxZkJc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vGVVMShC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8199D7F0A0;
	Mon,  3 Aug 2026 12:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=qR6eKlKwsVqJ2fBOlPW1CERKuW5dfE+bdWJIPXJpRCetRMTFRTSgZMIpcvOMg55PYQ0+6b
	uaTtErYcQ+XDggYDyWZznr7UMOefcejeHS31EAM4Ynm3Ysd8CCkXF+qTmB8kBzQQx4/nYn
	Y5n4T1zJLJR6EF3F07uY1ldMe4K4Ii8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=BZAiIMkwuhb/qHEtkW6r/ImNKzfl8pHpLKDer45EvsQZCeUvE8iP2gMB+KVkYVentFzyB8
	akCTrXS1lYZW4EBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=eLdxZkJcyym2hya8zcTwZUAt93qjx2KZ+287tbxat+dgcMMYVUceXOJ4YfIR4HaDvHj5xM
	IN8MU0c/aH5LFUOH6HcJMQ/+RkeDsyk+elIfR9LjFuJI+X3Qd20N/8ZXxCI1731sptJ8Nm
	V0Sco1KxyiapNkmQT6/Und2Qpatb7OM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=vGVVMShCSxEqBi+PBGqchTq5etMt0X1X5CpcTAnY7JNa+Bh/UW3yFjkw9oQw9XtWB3cMaK
	P2x7U7WPKmFP9GAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76A1F779C1;
	Mon,  3 Aug 2026 12:05:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5BXxHBSEcGruNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 12:05:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B061A13A4; Mon, 03 Aug 2026 14:05:36 +0200 (CEST)
Date: Mon, 3 Aug 2026 14:05:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
Message-ID: <s47cadp2vvo4ybfbivknswng3ze3fvldlcspm7mygzkmxo3aas@tivvzq4d2f6k>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
 <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,szeredi.hu,vger.kernel.org,zeniv.linux.org.uk,suse.cz,kernel.org,vivier.eu,kvack.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]

On Sun 02-08-26 20:00:43, Christian Brauner wrote:
> fsopen() records the caller's user namespace in fc->user_ns and hands
> back an ordinary file descriptor. Nothing ties the task that calls
> fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
> fd is inherited across fork() and exec() and it can be passed over a
> unix socket.
> 
> Completing a context from another user namespace is allowed on purpose.
> vfs_cmd_create() authorizes the create with mount_capable(), which for
> FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
> succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
> So an unprivileged task can reach the WARN_ON() in ovl_fill_super():
> create a user and a mount namespace in a child, call fsopen("overlay")
> there, send the fscontext fd to the parent and let the parent issue
> FSCONFIG_CMD_CREATE. Both namespaces come from a plain unshare(1) and no
> capability is needed anywhere:
> 
>   WARNING: fs/overlayfs/super.c:1551 at ovl_fill_super+0x7b9/0x1e20 [overlay]
>   CPU: 3 UID: 1000 PID: 3243376 Comm: fswarn
>   Call Trace:
>    get_tree_nodev+0x71/0xa0
>    ovl_get_tree+0x15/0x20 [overlay]
>    vfs_get_tree+0x2a/0x100
>    vfs_cmd_create+0x60/0xf0
>    __do_sys_fsconfig+0x4b2/0x500
> 
> The child needs the mount namespace because fsopen() itself gates on
> may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
> the caller's mount namespace. fsconfig() doesn't repeat that check.
> 
> It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
> raised in a loop to taint the kernel and flood the log, and it panics a
> kernel booted with panic_on_warn.
> 
> Keep refusing the mount and stop warning about it. ovl_parse_param()
> already spells a user namespace check this way for Opt_override_creds.
> 
> Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
> Cc: stable@vger.kernel.org # v6.5+
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Obvious enough :). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/overlayfs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 60f0b7ceef0a..60b808b85fc4 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1544,7 +1544,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
>  	int err;
>  
>  	err = -EIO;
> -	if (WARN_ON(fc->user_ns != current_user_ns()))
> +	/* The fscontext fd may have been passed to another user namespace. */
> +	if (fc->user_ns != current_user_ns())
>  		goto out_err;
>  
>  	ovl_set_d_op(sb);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
