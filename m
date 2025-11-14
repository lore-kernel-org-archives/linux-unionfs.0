Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6B82FDC4F
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 08:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763109615; cv=none; b=AFTZTZw4692oR8wZgbCiJWBJTWsbIRcUDUb+cGETzfJvrlCw/WMWKhFCcvtM+sHMokbx7elbOOVzYtaE6llBJ/l1AWL0kGHQPS5R/noX1YEunrKcBieCWpAjz7RNAzr+Uxsvcrhy8lGJepSyxn/Qcf/jrDQh+unBeebRCJkuDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763109615; c=relaxed/simple;
	bh=Jn8ZK4GsZJNhfPPdDS4J79dwH5A2hmQGPFAbZPYlDZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gi0Ey2TPRL0z6lGM+n6u56+cCCHOGm0DWazeF303Bm2U9WbsHK250EnFX3Aewjl8iFciKaI8vrxCRZyNxc8tq+PruZg8KJ1HonJPCDrGcFwBIpVNUEsQloYQh5mgcuRN+UjSXmUbzIYOR8QeilV6YmwDQyQVF9bTk/Mwa7RMYRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JaerscKf; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JaerscKf"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edf1be4434so7588621cf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 00:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763109612; x=1763714412; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1cb48UXKoNWccEdIeoX9cWYHZInUMZC/Q/uZyQIp29g=;
        b=JaerscKf9Gt0IfOVXHrDXPc4rjB6iu3D/2PhERVz+UvL+Hp/DaQciepzxnGg4LEmKs
         3zBrEatTsoW1MKAo5RzPXWQH11mdtxg/XUoT2+jiO4jLdQufkmpK8OdfLmvDTTAdTSA8
         RL6uu9yShSQY9nTNKC49MMdXQqyqci0rqacLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763109612; x=1763714412;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cb48UXKoNWccEdIeoX9cWYHZInUMZC/Q/uZyQIp29g=;
        b=FgNTX+bR+Vnb3NtKjY6wfAt0mb6T4zHmYZN0R3J94O48ewG1ViMzys9j7xSfsROCGu
         f6crZk10cfpTrLwuA+50nRhuVJq/nEhGGFt5ZtGkT28UrT8194454caF4DHEVp9wXNq6
         cvxiZCRBVRm/YOQJsHrs1zuJJkeJjXmDhvaYSQQileOoU0WV81+qzM7sbmg0HhhtSPvv
         VrZ1OJoRLP2CpbfEmOWhrihz0x8vj0Pqo3hf7PdXZliA5jIt2CSPcTfCsgMgFn+dZaLW
         ftqXmv/gqmPXl1gL4LVEa4zFsKld4AxQZQVz6okq+eRkVnYQhiB3tgYvFXnlF9ollEqq
         Jyzg==
X-Forwarded-Encrypted: i=1; AJvYcCWIdtBZg484HiJL6zkcnDpmPOZEW/iErp2nV7JPdVp+0nA49u2GOu5GEGH9pcH7ZOzD63+kZAtUhjy3rwu6@vger.kernel.org
X-Gm-Message-State: AOJu0YyEZK1jcnqN82dlUQwRwOYDTw+uD6gIETVywnGZJTCAWjJbve+w
	/EzDDYdU49l2F3K018VO0VF2+OYJMT/LzOgbsPsli/EW0ESEwJXZ+TjsaBMK1WVGmZbiaHmEDOp
	1PhzF69foDc1zSKFB+7AWsRa79UJ3gWns+p+hW1YigA==
X-Gm-Gg: ASbGncti1jc5hmpcDfVhcMkGNdc+izn4HYAdtmbSiZ+J8iHWzxRI3jrXsNSlEpnWayx
	Ycqvh9pwQUiIqEBXRx/EDld8yCV3oPTaYUWPEwBUaLXlFytp8pop72gTcTAhMrgD4RApGxo2Jde
	FXBmbcapKK1CZAs2Cz5uvtGsRr2ZqvZYWu0vGI+vDwzEkGZa3+K/ylpiLezRszAkoRUKTPdP78T
	WliIA54y6jHot8BV98UO7auxoQO8b1eoHOx5dv8+1mzCUQONs2wEJ6H6FPXX3wL8lXZIWF56/km
	UctJZxbB6L/oa3ujBg==
X-Google-Smtp-Source: AGHT+IEYExGpmwgALAyAiE3bEbEH/l/xCZ02vI9A1961kA1r2jyxfrOAGS78MScKS2e7ZhLHtivgMnRQvyxPd2Dbf0o=
X-Received: by 2002:ac8:7f41:0:b0:4ed:659e:efb4 with SMTP id
 d75a77b69052e-4edf20ed3c9mr35717331cf.46.1763109611844; Fri, 14 Nov 2025
 00:40:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org> <20251113-work-ovl-cred-guard-v3-25-b35ec983efc1@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v3-25-b35ec983efc1@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 09:40:00 +0100
X-Gm-Features: AWmQ_bmJYP551kqV7yMygpjJTx-gYuODzKKt9DdL2vHc4nXcnFBKdQ-lI-eZMVE
Message-ID: <CAJfpeguUirm5Hzrob=pBVgANym9wdJAEN1w7zEEuv-aW3P0ktw@mail.gmail.com>
Subject: Re: [PATCH v3 25/42] ovl: refactor ovl_iterate() and port to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 22:32, Christian Brauner <brauner@kernel.org> wrote:

> +       /*
> +        * With xino, we need to adjust d_ino of lower entries.
> +        * On same fs, if parent is merge, then need to adjust d_ino for '..',
> +        * and if dir is impure then need to adjust d_ino for copied up entries.
> +        * Otherwise, we can iterate the real dir directly.
> +        */
> +       if (!ovl_xino_bits(ofs) &&
> +           !(ovl_same_fs(ofs) &&
> +             (ovl_is_impure_dir(file) ||
> +              OVL_TYPE_MERGE(ovl_path_type(dir->d_parent)))))
> +               return iterate_dir(od->realfile, ctx);

If this condition was confusing before, it's even more confusing now.
 What about

static bool ovl_need_adjust_d_ino(struct file *file)
{
        struct dentry *dentry = file->f_path.dentry;
        struct ovl_fs *ofs = OVL_FS(dentry->d_sb);

        /* If parent is merge, then need to adjust d_ino for '..' */
        if (ovl_xino_bits(ofs))
                return true;

        /* Can't do consistent inode numbering */
        if (!ovl_same_fs(ofs))
                return false;

        /* If dir is impure then need to adjust d_ino for copied up entries */
        if (ovl_is_impure_dir(file) ||
OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)))
                return true;

        /* Pure: no need to adjust d_ino */
        return false;
}

>
> +static int ovl_iterate(struct file *file, struct dir_context *ctx)
> +{
> +       struct ovl_dir_file *od = file->private_data;
> +
> +       if (!ctx->pos)
> +               ovl_dir_reset(file);
> +
> +       with_ovl_creds(file_dentry(file)->d_sb) {
> +               if (od->is_real)
> +                       return ovl_iterate_real(file, ctx);

        if (od->is_real) {
                if (ovl_need_d_ino_adjust(file))
                        return ovl_iterate_real(file, ctx);
                else
                        return iterate_dir(od->realfile, ctx);
        }
