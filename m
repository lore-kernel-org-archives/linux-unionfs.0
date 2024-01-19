Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074D4C61C
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Jan 2024 11:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705663233; cv=none; b=jFdtu43hYCiAQlL+c8LXyjKvouQ5sO2YJi5wkXMKAZvQUPVAkTk/0VC5JsstSj367yiOaW8yQMHczIzV//gRfxuNWdL1lrk6gCfLRm1w63T4C5BbGCWiqBrlsnfBvMe5LeiYuRUXkKfUfCqCFXktxrFogpEVkEdB5P4ctE95bFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705663233; c=relaxed/simple;
	bh=Yn3beNcYVdkSQtS6/dBDhptz4UylN9AibkVXgjj+5cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f+NTQlgvY6ReD+MRtBGD/kMtm2TpgbS/qIHgFbQ5swxcycbbindgR+XUMn2NmvQ18k9cSt2nN4/EG3vSQx4NPdXs1pWKkW5vkxcZAdzVcMSL7Q+g4ipZ6IvjGvifHvn88kImJRn9YO1++e0d9p2sYvKtaZZd0Iqush2FnXhhq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=UR0ictAH; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="UR0ictAH"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-55a539d205aso741206a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Jan 2024 03:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1705663227; x=1706268027; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aBnEhmd7NsyYgMJlScUd0DjTZJ/ci/Yzod3zpcsS7dw=;
        b=UR0ictAHCO+Z+D8beR7f8YY1zuYjVj7ajXMPZaRk3i//F6NRoVfEcQ/+7cZPIyuOZO
         Uxnr8AfpnB4/Hx+ABeWpeu0FCRCSLFCgfMBU5B2JQwKqlLYCjk/v2ARvmfFYgirrmPko
         hLKQU3BkAet+naV9vczKLtkufn04EHZDlEjNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705663227; x=1706268027;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBnEhmd7NsyYgMJlScUd0DjTZJ/ci/Yzod3zpcsS7dw=;
        b=dZ/B3QMWRa6S8SWIQ3MjkDskEuN5WBBrBQfkAKpR2OrxMM4WEBemlfSR+zcosF5xZJ
         ptEpQxGOHnUU/wKxma8zkkjNK2jVfESu+yeVdk+1Xmasmr5VtoMg4I/grjbj1IpISxAL
         SUngDRizt23HzqrCpgStc7HgNa7ie7TI39l98Pr8c16ViRx2toKbMJnlg0O1TEJKz3Xq
         EhKlL+rXsvuMHZt05uENsqzj3Xr0VxqDzMrrvpz9T5tXqJSeDDRVmKSNuJZ9sa8980lu
         VrO8YJX+dlEdEFRboppb5sdh3Wp2rvNYAoFroruLp9VYQ25sgpap7nqIeJNnL/pwy9pG
         2xnw==
X-Gm-Message-State: AOJu0YxHG7dEb7kxLWziMlpREk5SjUT2At30yFovTuOw84KM3OKgANV+
	uqZAGYSc7YQUr1Y9L0ANmaTm0i/u6nBm4mnF5vAWduFa8ISZLuGr6EydCnkzjp0vFS/BDNupZuN
	s2znqH1Lls5KMgd9GYIFn1/BWlvHqa9OsSQx/Xg==
X-Google-Smtp-Source: AGHT+IFCQLaF1tDjz+sXrYQawR2okyMyjiGZHvJkLev2PMKBOhhjOBWThWDhX+/QlA1615Oc/gfaHB7iQZNRSNa3gBQ=
X-Received: by 2002:a17:907:a4c8:b0:a2e:d789:1cd1 with SMTP id
 vq8-20020a170907a4c800b00a2ed7891cd1mr1713739ejc.15.1705663227289; Fri, 19
 Jan 2024 03:20:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240119101454.532809-1-mszeredi@redhat.com> <CAOQ4uxiWtdgCQ+kBJemAYbwNR46ogP7DhjD29cqAw0qqLvQn4A@mail.gmail.com>
In-Reply-To: <CAOQ4uxiWtdgCQ+kBJemAYbwNR46ogP7DhjD29cqAw0qqLvQn4A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Jan 2024 12:20:15 +0100
Message-ID: <CAJfpegteroc6yJAmjh=MaqZOO9Q7ZJfg5BgMJFN3wdHGZK6gGw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: require xwhiteout feature flag on layer roots
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	Alexander Larsson <alexl@redhat.com>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jan 2024 at 12:08, Amir Goldstein <amir73il@gmail.com> wrote:

> > @@ -577,6 +580,8 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
> >         INIT_LIST_HEAD(list);
> >         *root = RB_ROOT;
> >         ovl_path_upper(path->dentry, &realpath);
> > +       if (ovl_path_check_xwhiteouts_xattr(ofs, &ofs->layers[0], &realpath))
> > +               rdd.in_xwhiteouts_dir = true;
>
> Not needed since we do not support xwhiteouts on upper.

Right.

> > @@ -1079,6 +1090,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
> >                 l->name = NULL;
> >                 ofs->numlayer++;
> >                 ofs->fs[fsid].is_lower = true;
> > +
> > +
>
> extra spaces.

Sorry, missing self review...

> Do you want me to fix/test and send this to Linus?

Yes please, if it's not a problem four you.

Thanks,
Miklos
