Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C093431E7
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 10:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769510587; cv=pass; b=i/SzXIE3ZdMxdo0o5HzdkLTxzXOggaiETFbi/UZBbzkzSLnhz+/ChKptiiJ/7Udqsv+F/eCg6XF8uxMpuuO/yVPx7l94tVrC2HEIUsEtwwAPi/4ugnEhT83w2gkEx8RT8yYOUcAfngZpgg7ZJB6Qs/F2BcWtZsXgg+fW9qLgaEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769510587; c=relaxed/simple;
	bh=e2vrIrrIOhKOWNoIRFUwhu6819NzsC8XDCEcA7ktvpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sIT0EvCFrNwXeCEL0hukTShxcTBVIrwPnN9HQ/wkA0DyxOo/1Sl95FTomkzVky5DNGQYBXXpE7pwsbVnwhznQ9QQoZtQpNof6XvF4/Bk/Yvc8InXiX8dEn2MPZit4igf39gv4HX+UrVc9gI77qggmSmCMK01xd3+YwOzKezmah4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=k2bBAvgL; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="k2bBAvgL"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5029901389dso50464741cf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 02:43:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769510585; cv=none;
        d=google.com; s=arc-20240605;
        b=hsrz1dC3QxBhRo+QLj0AmUaOU4Fi0zbuqM7plXL2FS4+LkpGtl9893+bfcQvO010Eh
         8oZ/RNdhDW6/ZDvPpyHJSfD2c+Xj74oZBD1aBWsjfw58AklooP2mY31qpOy9OQ/IY7qN
         ks1D4iRGOF+QbRrMgUZ/Lr+p6VS2f63oHwGxtlcVABLEqK+zalix3eFEitxwXvXHemQM
         PeG6ynhi07AypCLChO5iCUysWqWsBDlbJKLy3ZN0nt39EdV+H0LpQ7Uy7F5PXboBzUS7
         FQA249AaJar5ewsCrqu6HuTm4aE2jSsMWGwcKgHu743nh0rvmFZetq9qrT2ihSgDL0xN
         ecDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HWWjFXVfwflv3pzwi/dd+l/3BHLKcSfu+2zx61PZ3bc=;
        fh=HCRpv4yQUfCtYvga0v6rr6kQdklwjv3/YG6QEk5K6cE=;
        b=HZLJba93aFdSMQLXu4hOZa+0Abo1eAYEUuhfMF3U6JkzbOO4z9+Ytz9RdZMJth4gVC
         rlUiur3cvqGJJU1wajyR5FSX0tD2GdVRFae7803aqWAhY8CyxV+/vIvnUnbvko2Zx+70
         P8XLqNDpGlca4uiFOEheBgXZnOhTmagO259nGZwelvmEvzoosEKoKBFlaqU1rF2DSkoC
         W7ODIg0rUIbvCKXXoZgjQ8qRIPK0ifmUWOKvNcodUC3ffZ3wnbOWJPr03a2iWWSBzmKn
         ba3s231l7umb+ifIH6YIAH7azjTE8tYKI3yEbgpj7PNhuXqdU877Aet8DurHt4Q3WAiv
         QUFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1769510585; x=1770115385; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HWWjFXVfwflv3pzwi/dd+l/3BHLKcSfu+2zx61PZ3bc=;
        b=k2bBAvgLrq6bHy5LSFnsGZPfSYjffjVDMRuTDLHiQjOJrEdU/h+VZH50FBx5AzTEQm
         onVcIQipEY1swCe2medGEBBlKjM15l9uNFxQOYh/X/VPNAt2QKgPFi2n2+Q594Dnl0po
         fPT9AR8J/53muo0vk2WAFwAtaDqYCeKQ6XMGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769510585; x=1770115385;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWWjFXVfwflv3pzwi/dd+l/3BHLKcSfu+2zx61PZ3bc=;
        b=WsBoi03czAGfFybDNPBeEJ2X5WUypikLLztFifVXnXiNmlC6eYwH852w4IMfXa+T7H
         q+1xk0k2XAa2Mu/g9wp7Xk13R1jZifudpzLZhR2MJfhftlABfxSjAe0DXHnwoT8bB7su
         ESo6whHOlqq9I0pEexLGb90fyEURb7hcmESIF+6kv6S9/3zzflx3aS0JJ6368lpPLmny
         ey3AltT8wBqtk+bEYMrvARmT5O5njbAfX1+Oxc84aYHkOg+NZRszvEU5KmpoWw1UXol/
         QfxJEf3+3A8m1m5nfNXjpigQluzZ8hHTRtTqHvr63jmWnOr8G9DbspO/pD+2U+l0uRIs
         J6kw==
X-Forwarded-Encrypted: i=1; AJvYcCUCz2swyKwlDRcMRnK6EyECoKaftjEKMBoYibG4PMFJ46SP2vWQxKXmSxkvlKUwMNgdPSp8o24VbQ4dvCgl@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc7C9VbGcv6jmaiQvrpJNngjgSYI262zCYBb7oOukmO8DRYW4f
	z6xNdMMkmhabAdtVcZNCq2RdNBMzwNOY8QS6zX/36QaOKogXl8mJOyl/7EhnJ8mNsbXwYNrYkNz
	K2rxl/VXFnE49zMKR7ggIrBoNyH+0IU2pjp0S+AtQ2G9tSOhv5+WH
X-Gm-Gg: AZuq6aJvDeQTFkmPcY06kqld2NerCQpypoWnTH2hHKGcEjf2RxX4Jq+iLCzrjBV1U47
	DZDVHAb48F/vEI9SXBR6wrKdu0LAWukpolmxFMK6FiS7uF7SICqdxZkQfKOmKVSJLkctrRlr50Y
	8WdzPeCDvSF9zPFdKvkytzH4FQ+g45W51DRQdyhZ63ZFu6xizJivJCr8PM6YL89TKmv8+28o10r
	xZIWJZ1zHMtPHnVo5ya47Ou7wIkLeAY5P9nXyAxdpDoVjlhoFM4+vLJaa2FdJG8aD9WUwU=
X-Received: by 2002:ac8:5dcf:0:b0:502:9ad4:efda with SMTP id
 d75a77b69052e-5032fa1c992mr11335951cf.55.1769510584948; Tue, 27 Jan 2026
 02:43:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260127075404.1110552-1-wangqing7171@gmail.com>
In-Reply-To: <20260127075404.1110552-1-wangqing7171@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Jan 2026 11:42:53 +0100
X-Gm-Features: AZwV_Qg80h2T0Lh5wexCSKDBEno0wBtwBHUBh2qkrAXXUj35f4NwOby_XiJ6nyE
Message-ID: <CAJfpegt_n85jDSe9k9GcC_9KB=+R_oUeJTPt+3XSPkhjBPm3NQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Fix uninit-value in ovl_fill_real
To: Qing Wang <wangqing7171@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Jan 2026 at 08:54, Qing Wang <wangqing7171@gmail.com> wrote:
>
> Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.
>
> This iusse's call chain is:
> __do_sys_getdents64()
>     -> iterate_dir()
>         ...
>             -> ext4_readdir()
>                 -> fscrypt_fname_alloc_buffer() // alloc
>                 -> fscrypt_fname_disk_to_usr // write without tail '\0'
>                 -> dir_emit()
>                     -> ovl_fill_real() // read by strcmp()
>
> The string is used to store the decrypted directory entry name for an
> encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
> write it wthout null-terminate. However, ovl_fill_real() uses strcmp() to
> compare the name against "..", which assumes a null-terminated string and
> may trigger a KMSAN uninit-value warning when the buffer tail contains
> uninit data.
>
> Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 160960bb0ad0..2581cb33fb87 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
>         struct dir_context *orig_ctx = rdt->orig_ctx;
>         bool res;
>
> -       if (rdt->parent_ino && strcmp(name, "..") == 0) {
> +       if (rdt->parent_ino && strncmp(name, "..", 2) == 0) {

Need to compare namelen as well.

Thanks,
Miklos
