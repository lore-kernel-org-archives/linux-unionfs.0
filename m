Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C92B39A054
	for <linux-unionfs@vger.kernel.org>; Mon,  3 Aug 2026 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785758762; cv=none; b=jwCE+AqScDDcl3MEXuFyBQTh1O1A1DPx1Q05SI2CRJP3vHjNjJXJrx5i44tJaiOn7PuBbLDP7P0rDyq7RlJGpr0j0LOavgg3cTv/iBafOoNbsDkUu+vijI/Kl/EQWwLaIyPSTW+a5hjsnjsTLx/moO7CiUTiLHXCxFYC1aOYeXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785758762; c=relaxed/simple;
	bh=FqQL/bkftyuKXdmwifYdp6hNSCMqSk9EwtOSp9rqJSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd9hmKzFrmsoC0zUtjXybVnUkai7dqZvTtM0W4261mbQjc5+NZ0Ntn+ALisq9s1WK0cZFydKbAoa8wkI4ckisgSxm/8OoPgY6HIryoa3ixBfAtcIXlNd34oFxcBd2QXar+lrGLlRjOydREkjXk0CRjuU8d1myV/lDdIgfcDYxPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oOx541gt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FLE+1tID; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Drjhk3Pq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V/OcfPZS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oOx541gt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FLE+1tID";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Drjhk3Pq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V/OcfPZS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A6D07F0AA;
	Mon,  3 Aug 2026 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=oOx541gt22lq0QRWXu05uXqeeieN9svZv+KvcMIQRImXrRzMOUwVLTZdNErb5NtrdYGB/z
	8Zhm5/2jSj3eKXit14/TXb38D7L5/mlfpE+wJ65q6TNL8KfGt93bxn7YlMHX9m1gmizD78
	9M8x8WUVGODr0S/CnGaQqkFLQZO6ZYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=FLE+1tID/Wg9Wvs7Ii4sUKFfMXzWF6OgwZ1IPgy2Y6hEnkjXmLVf/iCseBI+2F6DnN5h2R
	4XwjEl47MmhbQbBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Drjhk3Pq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/OcfPZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=Drjhk3Pq9Sl/s+EUwvpzBJ0Qfz33eMwIckfN+kal47jxKyxzyxY7SoSg5mfiVtJFkhtD1Z
	QUtvxkO0/KxvPqx4wYOgqzrTCIcHapmvPHARtlZCIpTN8EYAlE9yOYyJv2qpuT7Y7hqP9m
	RzVA9a3m88BVWyS39jBZ7rzohJB1tjM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=V/OcfPZSDwBwcZJAnrKc7JHCc1svX0Q0GGpuWlRO1F1ux2MiWqrbUx/ffnzWldyufmkJRj
	vYbE+01VEWYc7GCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 907AB779A1;
	Mon,  3 Aug 2026 12:05:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B1tGIx6EcGp+NQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 12:05:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EC94A13A4; Mon, 03 Aug 2026 14:05:50 +0200 (CEST)
Date: Mon, 3 Aug 2026 14:05:50 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_misc: don't warn when the mount is completed
 from another user namespace
Message-ID: <lp42anrqt3khwf4fyp56odomifxeuitf4ejxahhxns7ze7nyha@dblztvmz4ocj>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
 <20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,szeredi.hu,vger.kernel.org,zeniv.linux.org.uk,suse.cz,kernel.org,vivier.eu,kvack.org];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 9A6D07F0AA
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sun 02-08-26 20:00:44, Christian Brauner wrote:
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
> So an unprivileged task can reach the WARN_ON() in bm_fill_super():
> create a user and a mount namespace in a child, call
> fsopen("binfmt_misc") there, send the fscontext fd to the parent and let
> the parent issue FSCONFIG_CMD_CREATE. Both namespaces come from a plain
> unshare(1) and no capability is needed anywhere:
> 
>   WARNING: fs/binfmt_misc.c:938 at bm_fill_super+0xa2/0xc0 [binfmt_misc]
>   CPU: 15 UID: 1000 PID: 3243382 Comm: fswarn
>   Call Trace:
>    get_tree_keyed+0x7d/0xb0
>    bm_get_tree+0x34/0x90 [binfmt_misc]
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
> Keep refusing the mount and stop warning about it. Nothing in
> bm_fill_super() depends on the two namespaces matching, it derives
> everything from sb->s_user_ns.
> 
> Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
> Cc: stable@vger.kernel.org # v6.7+
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

This one as well. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/binfmt_misc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index c97f10b48b5b..613dd28e3f1a 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -937,7 +937,8 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  		/* last one */ {""}
>  	};
>  
> -	if (WARN_ON(user_ns != current_user_ns()))
> +	/* The fscontext fd may have been passed to another user namespace. */
> +	if (user_ns != current_user_ns())
>  		return -EINVAL;
>  
>  	/* Never exec off this instance and never let anything stack on it. */
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
