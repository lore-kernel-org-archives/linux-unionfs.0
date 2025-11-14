Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BE6224B14
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 07:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763104192; cv=none; b=NceP7a4u3lWdeIm1I1d6uG4mzyCKBoUhJpU0VlykqP7LVtsS9VxTy35FgngT6QpVkowqiAEvOKabKRy8rLQzcqSxyCctPn2Dtov5N/Kz9qHVgu5ar6cLBj/1e/EwZsJWQOAP6sRgCE1eQfOETS3kTdqb0dnE3zHsgqQKar5xAi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763104192; c=relaxed/simple;
	bh=E06eWH/B19XQlvXFz1DPzyDdhpFnpRK56zuzDqc3nDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hfWXKo8yYl5GuNM+KEuOaKiSGUBCCPbiB7LRYM5GLObrZL+huutsxOPrhDnUz/KG4xemsXSR3hphWAKrqps+Wjy/b1UJ+nRHgEdtxFsRuMF8sHBx5zY1ey6h+sslGRRkcvbmwliRNlRzBP2EyCC4p92yRKdNbXD/6p5XP5IKBIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ZEGNGLmm; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ZEGNGLmm"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed59386345so6836991cf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 23:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763104187; x=1763708987; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SyZzeGaFJhk0rTaUbsr78GBXbJj3F8nSjFa0Vp62350=;
        b=ZEGNGLmmrCFkPujjRkv6c7sIUGoJxCAtcWq2Ghn8xkxb6Rzh6B1MP3TbtHYSOBKllC
         pCvm0cZ84WjOuEYjsC2ctZNF606l5VCDdytMVY2t1oB2f++p14szVvL2TBeI/6hijUpP
         c/Z/tqTVSu48yhVHgXZtLsd8Px0j54BupxiTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763104187; x=1763708987;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SyZzeGaFJhk0rTaUbsr78GBXbJj3F8nSjFa0Vp62350=;
        b=JN76iv3s4NBNVO7a893WoYMO+KbbtlvWhyM4LfLn78IZE5uE9RVRSG21efRmAPtEtC
         +TBn+AgDGa0LSw5y+mkAhssVOygC7E0BPc1jRzQuZcou7GXe7kjohtcaBfxC3paLbEpQ
         9/axYWoal9tgGpDoRype6NtNonomOBs+7cWD+dJgH/lEOv3I7ClSmLYwfd49BANQvwLq
         FPDhJDZz7MYFMcVNNMj1/53Dw5+7Cv9TL6cMhJp7pROMcYXfQWok1sFycETCNtmCk/6g
         bwR8bWmjNKLnw9Qmzk5bCeWtJ3cC7UajTkaDD7ugED3CPuIUAtfoxYwmh1GA/FpH1BKv
         dZLw==
X-Forwarded-Encrypted: i=1; AJvYcCWCKKdF3Nxbaf/od7YNHi/m6NKCdnVtp3WW6vqditG65OLfVsXB1gvQ3bEbbJU2bpxqq4RSBQ+m6vbyoy2k@vger.kernel.org
X-Gm-Message-State: AOJu0YzoaFEGTXG5QeZqsQReplCQvWANMe676cdZvLvmtEs9vC3m6BkW
	QuIBFmsTlMQ0w96oY/4K//Y0EAmFfROsa/dsKVmUwPQQePzqatc2XcEYfIt/3hb0IzVYWzthHQw
	Zrvg/WIlTs7eSZB3nuT6VDUNrUsJMA48wUJUd6X2vW9KeemEbGQwB
X-Gm-Gg: ASbGncs+8BbwXAKjjsAPRGWJoNGhygzzUB4HAIU7JPdEgCTvny/Spdix70xOEPuTKLO
	uBu/DtUrGRGpTYg4MTVLItZBMIe4bJpEG+1q9Ito4fq9bDLkwnublNd3q0Tl8qwxo8dDHEFrozo
	IjTCf5BbvnEIHvs0WNdqg2vBmatLSsfR7oUuif8l0Ue5skIUTWuH2Ei3dW1hxMpQjtQNXap052U
	o/jVLFDy0iWMJshnT0f8qJlOb8UJqSISqpbX7b/9o/qfz27oEUvSqG1MQ==
X-Google-Smtp-Source: AGHT+IFOSVJvXV1OcjbCp2tNCmKIqjhBe/HN4xDG2P/zX6+RE9u8PQoIv/hpBwulbdMxQR8y96wz/zC8GlmXCJvFWmQ=
X-Received: by 2002:ac8:5890:0:b0:4ed:b6aa:ee2b with SMTP id
 d75a77b69052e-4edf2063f39mr34591371cf.18.1763104186667; Thu, 13 Nov 2025
 23:09:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org> <20251113-work-ovl-cred-guard-v3-3-b35ec983efc1@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v3-3-b35ec983efc1@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 08:09:35 +0100
X-Gm-Features: AWmQ_blmZknZYznECSy4HXGEdaW63w0Uq9RQ67Oq-ScGROKoZXIUAbDUXPVUGG0
Message-ID: <CAJfpegtLkj_+W_rZxoMQ3zO_ZYrcKstWHPaRd6BmD4j80+SCdA@mail.gmail.com>
Subject: Re: [PATCH v3 03/42] ovl: port ovl_create_or_link() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 22:32, Christian Brauner <brauner@kernel.org> wrote:

> @@ -641,23 +640,17 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>                          * create a new inode, so just use the ovl mounter's
>                          * fs{u,g}id.
>                          */
> -               new_cred = ovl_setup_cred_for_create(dentry, inode, attr->mode,
> -                                                    old_cred);
> -               err = PTR_ERR(new_cred);
> -               if (IS_ERR(new_cred)) {
> -                       new_cred = NULL;
> -                       goto out_revert_creds;
> -               }
> +                       new_cred = ovl_setup_cred_for_create(dentry, inode, attr->mode, old_cred);
> +                       if (IS_ERR(new_cred))
> +                               return PTR_ERR(new_cred);

put_cred() doesn't handle IS_ERR() pointers, AFAICS.
