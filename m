Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCBB4756C5
	for <linux-unionfs@vger.kernel.org>; Tue, 18 Aug 2026 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787058913; cv=pass; b=d1uB550lDxKReNqDoy4o47CnYFA3GuMJmi3ehnM6rMRbatHQgKUpYGM80DQpTF63t4p7t+WMt0nJDvh5ckGc4VbxMEPJCiFLFVWnY1hTHmr+BTduO+0qHRAhck7jaB6dtvzop0K/Ayuc0M42Sr0/ZQN4fkwTLDM14e6o2B94h4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787058913; c=relaxed/simple;
	bh=KmOPgecutUsmjwBlgKM8KuaPjy+z2DOw9/Sj82TrOBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVBjwav5lghAIdVu0wm3puM+PaENHAtDyBTefvii53EZhnnxiqSvo1mRItVqW2cVdD27jLLpdInhLFUk9mRjrqAtM3icd0wc341EnNxIXhjfrD2u4KDfW9BmzW8gxHGQhCw9DotBEpN7sVjarSAVlJHC36pwUBubq4ax5oHia5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=R7WpH7XQ; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="R7WpH7XQ"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-936e393176fso159565985a.0
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Aug 2026 06:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787058910; cv=none;
        d=google.com; s=arc-20260327;
        b=CgBKzgovgcAmfXvsNcIVEJ/oS7mYlWI+utmQ0vgwtwTK24st5/Exm4ZDmWDF/QortX
         D1xxeqNFYyZXsMGAXyQluoNTqvgBUrqz+3VRg+7kRo/7htIy+x1bq1+m23YExI5K62QU
         L2gkaJvtESEDdA7RHDaaqPhqYffmwP0CNMQZTh6TgWAfac0iPHKeZdU9K+Vb84LKsO5q
         7/0t3IwPoUVTlW4tMzSAGZp5cABHFGzpgRkeWLKl9q/dupS6N168h+6UXPP99fZCq59N
         cBtYZ2D4lj2oXtOmI1ZmzSJkuIc3rWPxnpM9nKeSTpwVIyqk1b8Z94PI7QuzWQL4uiPF
         aBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
        fh=nBfmP9y2+gVhLBxUw6s56Fl4tMVe4qFOqYhrJ+syWOM=;
        b=XmNgfm9g5CTSw0RJW1HktGzml2Ath2FxxezMGqXtOpNMYLdx+YaNPSVEnuEJw3gngL
         7igqxamEDWWz76XfSQOhZ2Pl2Z1+G2dW/dQ6VU2RoG/T6/92bPCZBmRqV36KtxcKXilC
         LqOpFSR6O8+5G02LOTX2ELHslHCqzR14l7va6Eu7AccRaMgjoOkT1PoT42wBZ7jCYn13
         1xZjzxjN8jCS976z6X5O1ElrL+yPPAd55K7D+nsQz0KaXMeHap750Ajz/no68wIWly39
         wriYItsrMrlNaSRMLrtP5I8dzv2i8YAFNDLeHtMh+n2n3Bdd8aBZZuinSQQt5rjNPJsb
         /cjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787058910; x=1787663710; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
        b=R7WpH7XQU+s1dPr0CcPCikdC0N2EQs40h248ps8kh/hFM5N9xQ/hD2TfPWcl9xaOqz
         PWrcFWccreowAZlgmWR+EvyZYndrZ96uTCaa8V4GzKuPrf6C7X8+VoTjCI4/WSAJ65KD
         4AOjAy8XRa03bEX8khTR8J67UGihvM+9P8HEA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787058910; x=1787663710;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jxh5XpAHdieXwLPBDP0ROoYTT/Q1CVkQ5V4OzfSiXHI=;
        b=cx3vppNU1BjG5KqCp4Q1BFNT1bAo1Uc3zAxSjYBuj0OhUzruE3n+TNHF1oKstdCn8c
         XwqJ/UV/XYv2czaLwsiYfYfkEA/8E9gVC77QPLn8wW8ooF8Y1A+Sx7+Q6Zu6viTM10MP
         Os3iGxEzqAkYKljtItaqLw+VOLHjynQSori/2rUbLY9bARO4BXowtMTyq/3aTv9SITW3
         2wwlW/ddYia15jNYOwXz/fgOzA1bVY0YCmX4W8Vr72DnHKUYnVyNAklCRlzxZfLrLbhq
         MiQMv3N3Hs4mB2r6FvM3zB/yq5jTPEa2Za6El6PrbJrECpkGtSW+BaLga8A9b8Av0fHZ
         cKZQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIsdQPXs7GASKwqP7+27J74iFLnXOIb9f1zjYu3yYj1zpOWzZvzaaksbI0x07Y1g9YKPITx3zU1hjOZUpR@vger.kernel.org
X-Gm-Message-State: AOJu0YxW9+sHf/7YRpcM2Hc1TAEeIRaZvm6MOKo7kgOwzKjSAp7LWHGV
	+ysxp17IpQEFYtNDSZ6Zvd6dYE7TYZ9hoNps5kytm+ZM/zBsop4wxRedrZm+egA1VwgHunqVh00
	iBsLgIf5VyoHpgMwk3TaL0LuaQSDn9ICyrYpZRtX9Ug==
X-Gm-Gg: AR+sD118jPXELDVtn/ND9V+eUBcTHn9kxAwJW7qGpVjIT6anNqPH4xIbDjdeajo3UNJ
	/WIbK+ghfeTW4MfTLOpLVOGRpIs2TOEFJVwHJIs2pLmUrkDvYHSMgMbrMg+5NyLCeiZtYD9bx20
	klmhotQDGiIFh9BMCf4a8oBfNqTNEC28fn/gt6l10h3KbWaLd+ks3r0dpV9mRzZQlDxsM731Z5z
	HwOBt6HJ0saJ1Y03JEgb8qKU/fnCRJraCsOehVkJN1T3n+39lqLr1FrnYmeR+ahCgg7nuxsT2P2
	+vUUCR1qBo5qxWEb4U1OFkucjdeKl6scM68Kn9Oxjb0fpjyvvSfwR1N6bjX+WT/WnNmGtyfFDr6
	l
X-Received: by 2002:a05:620a:404c:b0:936:e3c3:8cb8 with SMTP id
 af79cd13be357-936e3c38cc9mr2458814485a.45.1787058910323; Tue, 18 Aug 2026
 06:15:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org> <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Aug 2026 15:14:59 +0200
X-Gm-Features: AcwNN1UBQAWcx1tOEiU47Frr3JyAbsHxepEKWSi_zYBw_ITdoj7CtNDGWqz3aiE
Message-ID: <CAJfpegtXbdpFZmV2dYSbp6eL0DBGmZin98TFr42nxJCfuryfrw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 2 Aug 2026 at 20:00, Christian Brauner <brauner@kernel.org> wrote:
>
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
> ---
>  fs/overlayfs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 60f0b7ceef0a..60b808b85fc4 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1544,7 +1544,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
>         int err;
>
>         err = -EIO;
> -       if (WARN_ON(fc->user_ns != current_user_ns()))
> +       /* The fscontext fd may have been passed to another user namespace. */
> +       if (fc->user_ns != current_user_ns())
>                 goto out_err;

Just one comment on this (I know it's been merged, will do a fixup
patch):  EIO should be turned into EINVAL.

The EIO was used to signal an internal error (commit 9efb069de4ba
("ovl: add warning on user_ns mismatch")) , which is no longer the
case.

Thanks,
Miklos
