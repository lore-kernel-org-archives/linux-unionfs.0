Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794754480;
	b=TJhndI8/uEhf+/lWFGTQmkd3suWSKjaHs8xok3hOBApwjQlE5chreeQP9cmvDj9bhaK0
	 HPpX1igJSzQmNN85tX7x0VwfLGbDMrm/5N7HMuDyDuiCWx4ee/fsMfqkLetx7GD//FWUf
	 aLTjPzcMLG9/JPkIzJJdPhog+VsVEnzlnfybEg5n/JBMOewAftRZxLhIGVqfpo55t32SW
	 CvpsXWpa7r0lJWuz9XW1JhH77cdzHkMDb1uvX1gykD9mMCcfKzQ7t/DZWx7/QaV19uI68
	 PslhEF6qpZcB9pvOwGeQz72u8B7mdklOP4VMkeCm35EwrkWXm0/A971dxPHUPI6jz0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
	b=prJtAwO4pR+9PqQbPVsvaeGj7f5ggaiaaGdE+1qX/xrQ22ESWCD/Y3gsWRCPJX+BI56D
	 vWf8BagzrePtGwzX+jzRlJdLMG76Ezdl/9wfXl/l6uiDLDU04E6rgDaj423o5s5Xn4dpr
	 nFbb0YM808AfwtfUUY5gTySpHxjdCKEjpSI1nTCFeHLNEeXoV+f2AZ9363KKTFnsA9R2w
	 jnysMkTK0WDcclIEMxmr5gpkTWHnPZ6Y8tEz/lXK680ul1Nm1unviQ0yDyPZAXhLAbIoH
	 mmAnXfADP/pUPKdj+/5uP2mzjekv+M3SRMMqeEm5EpQwglfU3BYhG02uh9sz0SQco4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nene7tW5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288BB606A31E
	for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 14:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 288BB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nene7tW5
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b65d69f5c2so3813159a12.3
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 06:54:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754478; cv=none;
        d=google.com; s=arc-20260327;
        b=i9x4ZkMoz/gNivrk7n4klFLGAZBtu7eKs6LrNgcblbZIxgxywWNrBT+G6N01nCeo11
         QdZHvxLQ9trSEUQKPlplQnS+e/ykfd8Q70QX/S3yH5VU7ALIWIlrO+T6WeuMAWsUMxbJ
         Ov5HD4pzHN8AIddWG4GgrDSHmYwDytdthBG0Bbv9YESx86nurNTVsTgSVlrsYKdTeTzR
         QgQmcvmGzGX94RNqB9npmqVEd53/CgFqDwZ2PIoHIwokl3O5+K9+8lMFIbLC6S6zXS2K
         c2j1zXNDO1kkUMUMR5o62F7YAbITU6K5oVq2xC0RW6BI9ciB3usdm36s7cQ/WDtbZ8qb
         EnEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
        fh=DWtIy47lrEMRUy6/Mx8dMr6lyiGvHXKZyLESl67CFkM=;
        b=NGqfIE1Z9qTzCaBNHu8LjVhm6sLkJUNCte7gmy0Bpovkr8Cxw0omqLeZj8cTS3TBIw
         O8d2Uig9h8geeVZ/7lsWB7MtpmWP3CDX+H7Gqd7dxh1FYWiw7RgwoXekn/oZUIE2DknD
         kwkw3BZGRfR0wa4//BXU+Fy69yJtnRhF9Ilb7+TpyC70qd5ZSS17IQAANcXJUIF/qEqx
         FGDhyFhfqvGnekcx+F6Tc5PiPgMT2jqQpblrZO5ddg7Z5spQ02TveZ1PUH4ai8RhyXA0
         w2EmZ/6enBLdkZsPNpBcSTrFNVlIQx/xmShGD60eJBGRIJOo7HfAk1s1ig+mzoNJ02Mp
         FLOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754478; x=1795359278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
        b=Nene7tW5gi/n28xM9GPcsrsbApaftwN+5VLijlNSUx682MtoFHHSTEvDl1z11fpu1X
         HvQApdaPQrGfQyiS3FbYQVWjhD4Evwt6P0rS5BC7bOQTZVXFLWaPO4OPsg6ddRko0o+q
         9oJBo3AXuMJZvhtMaEl5yxlnDv3/Y+/ZTOoPRzC8SnU76nRTNG9VsBQOFmcVN+eTzILI
         pLq9xeN6fA01RGoB9NuHnqix3fuxZlQryfHYntRw18u5V1gyWgLisGhonGsU8L2T6Lkf
         J6bkZRN93M/WAUT22qxzPXNMWojuGB568xJ5NJFT1QuthxcS4hfC3ctLRiOXitSCJ+gM
         bTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754478; x=1795359278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oqISismNDREzK3BapMQL3oVfFqMKLBzQ11G0pwa4rCw=;
        b=era5pCetrefeqBwak9RtENtkTEDnfU+gOmaVL43WCZXdMw2xujaHBnVbdvUC9LX9EO
         NcQMOU3g5PW3jN5Pl/vuW5nnULc1vlPEo6y53GDI+UoiS8n2wPYny6zs/ZksRT8G4ldv
         tTEAHtJ8Q81mtjxnY0EKJ6xzhQyugryCBctIuFpNc/eyfsiVu86nFBZTeoLMt6Hp9M4B
         EILgeekIU6PsnnIbjXAzEirCuT5KL/hJsNycvtQgw2QWYXJRyOlRe15MhCgYpMkHjH5Z
         6Sjc7OgbqoZpVEXKifke573pm4x7lH9n36B6sPxfl4cUSFJKM7IgsqvUnv67pt0OMSCd
         5+Qw==
X-Forwarded-Encrypted: i=1; AL+hErFmhuVEDM9xGtTWcX1PYduuZGl/Wl2HJzqI0z40ANRrEr1byAZhQv/dZIL4SIBK6+2URevC/SmOFIuD8wan@vger.kernel.org
X-Gm-Message-State: APuU4Z+wbpQlq9xd8A68AUw5mM8PsP3ma9vsWYNe4O1sogXLlOdZJ8k4
	qJjQnZjfUm0m9PSGHGe78l0uMLUjZUBl5Rjn0Y0Qrgf4UjA6hogIiZEybL2Dp5izW9pQTg5ty5M
	+Mj+ZDIBBbts2QMD0T31ZJz1Ek6nmY84=
X-Gm-Gg: AYBFou1r9KEwqJO3jR9h075IgO43vW+u0wZSqtDD/enfrMWqhW3A/Dn2ftYFAxWpP4G
	5YKY52fGya8ca6SA8TRq9FV0q55aof9bOkPGw9TgAQTaBu1m8dG4oNOQJElfJC7YmND0EB0GlW5
	QrskZjK10dp1AZl2QA2qoq9hEyn5i5FmAOUDJI70WlDwVTXdoQy2iOO3iKh0NV8fh85xsCZ+bE+
	rbOOY4Vn2UKQQasO4ilMK3YD4RLf1ILE5fQ6s0FjK9iBShmdklGSVzR2FqIGy4lm6lXUoNjI3hS
	pZMOCIlW0t/yB4+kR8ezPe5s0MctKd7pLzsaaf0QsySyE96Q2wdPdFS0NsXPy7/7nJALul9PIz5
	T/pqGq5Ba4D1VX0JLlcoA+hwdlco8NjOgvqeD+4lyfKjR3sTIHdPDhp4Cz4u3u5dQnlCKIw==
X-Received: by 2002:aa7:d1ca:0:b0:6b1:c2cd:db0c with SMTP id
 4fb4d7f45d1cf-6b7c0957c1emr4306146a12.10.1794754478075; Sun, 15 Nov 2026
 06:54:38 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-1-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-1-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 15:54:26 +0100
X-Gm-Features: AclHuK8KXHVL-duO-F-YZ8XPwW63n9hxew9z3khJWwo4KtxA0bTnHEz-HW4OPxU
Message-ID: <CAOQ4uxhkqQE+ONrcgJNw2Jah59bKruxUAsLohTtKnsgTVQBw-A@mail.gmail.com>
Subject: Re: [PATCH 01/13] ovl: don't warn when the lazy lowerdata lookup
 fails in ovl_d_real()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 3:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> ovl_d_real() looks up the data of a metacopy file in a data-only layer
> itself if nothing has done that yet. If that lookup fails it WARN()s and
> returns the overlayfs dentry.
>
> Commit 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in
> data-only layers") assumed that the file would be read before
> trace_uprobe places a uprobe on it so the data would be there already.
>
> But nothing actually guarantees that. trace_uprobe takes the path from
> kern_path() and calls d_real_inode() on it when the event is created and
> again when it is enabled. So a uprobe on a metacopy file whose redirect
> points at nothing warns twice:
>
>   ovl_d_real(/f, 0): real dentry not found
>   WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210, CPU#2: sh/27=
9
>   Call Trace:
>    <TASK>
>    __trace_uprobe_create+0x1869/0x25b0
>    trace_probe_create+0xcc/0xe0
>    dyn_event_create+0x46/0x70
>    create_or_delete_trace_uprobe+0x3c/0x70
>    trace_parse_run_command+0x1a6/0x320
>    vfs_write+0x1cd/0xfa0
>    ksys_write+0x116/0x250
>    do_syscall_64+0x10e/0x5e0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>
> bpf's uprobe_multi does the same.
>
> A failed lookup isn't a bug though. The data can be missing, its verity
> digest can be wrong or a signal can interrupt the wait for the inode
> lock. ovl_open() simply fails in that case and
> ovl_maybe_lookup_lowerdata() already warns ratelimited about failed
> lookups. So return the overlayfs dentry without warning. That's what the
> WARN() path returned anyway.
>
> Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-onl=
y layers")
> Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata=
")

Nit: 42dd69ae1af4 came first and opened the possibility of goto bug
and then 184996e92e86 came later and depends on 42dd69ae1af4.
I don't really see the benefit from stable POV to name the later as Fixes

> Cc: stable@vger.kernel.org # v6.5+
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-214581@kernel.org
> Reported-by: Chris Down <chris@chrisdown.name>
> Closes: https://lore.kernel.org/all/20261114120557.4bc1eb6e57218cdc@chris=
down.name
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/super.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 08695a99f4f93..1985b553a47b7 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -58,15 +58,13 @@ static struct dentry *ovl_d_real(struct dentry *dentr=
y, enum d_real_type type)
>
>         /*
>          * Best effort lazy lookup of lowerdata for D_REAL_DATA case to r=
eturn
> -        * the real lowerdata dentry.  The only current caller of d_real(=
) with
> -        * D_REAL_DATA is d_real_inode() from trace_uprobe and this calle=
r is
> -        * likely going to be followed reading from the file, before plac=
ing
> -        * uprobes on offset within the file, so lowerdata should be avai=
lable
> -        * when setting the uprobe.
> +        * the real lowerdata dentry. Callers may ask for files that were=
 never
> +        * opened, e.g. for uprobes or O_PATH files, so the lookup can fa=
il
> +        * here. Return the overlayfs dentry then.
>          */
>         err =3D ovl_verify_lowerdata(dentry);
>         if (err)
> -               goto bug;
> +               return dentry;
>         lower =3D ovl_dentry_lowerdata(dentry);
>         if (!lower)
>                 goto bug;
>
> --
> 2.53.0
>
