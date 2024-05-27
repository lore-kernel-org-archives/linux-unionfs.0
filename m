Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594613BC3B
	for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716817872; cv=none; b=hDhPvHoEEoiv1I9Vpc65zdK3M8QUbMukFysZs2DoYo2K1PFlF/Kw+wmuALMZjkY/GTDMlzVt7zrScCLN2k7WOxyqc0PbZB08PUYmFhu+wq93VZSzN8/6U1rxKunxllAGLGQ3AD8qtqV5fsI7vvjWXcR8TkSmJgSJSk8LdbXEEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716817872; c=relaxed/simple;
	bh=uuQY43wa+0cys4WzKZsdo95EDIza7dv83nymBpPfuio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dSTo/abiVlsetYKrU7jqRlOAx4HvhakhHoAxVjjW+mxq5Sqsb3zfukHtThvUbwJJmGkMp9C2Z0pg2fr+epPKDWUl9Gi6+pMafnVwm9iTT1txmGUWe3k3Oyg2g0WMmnsMDAiXPQUXgsqmh3hGnF3sCiuE3a4mSXAuc8BGzPrwX8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=CEWDhMIg; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="CEWDhMIg"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57883b25b50so2110283a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 06:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716817869; x=1717422669; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uuQY43wa+0cys4WzKZsdo95EDIza7dv83nymBpPfuio=;
        b=CEWDhMIgwS6jcTyM9CnO7Rs5RJSfU/Ovrj3b06MqDJ6R0YIYvhzNBppzLFJqGSdNmy
         XiTjn+ECfLvvID5/oJgG0etMRFTl4BEZEDxCCZ8SNhtcOx3apaD8OEhdO5DZaGW065Do
         cZdNLeGeLioeciz/B5oH3VdXomvPXOPafXkds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716817869; x=1717422669;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuQY43wa+0cys4WzKZsdo95EDIza7dv83nymBpPfuio=;
        b=i9THxOZWn7xqrnlDyycJt02u0subURYLdkITSa3Be+8WypLiJJ7zHH0qroivwZnzHv
         ktvEto7v+SNZd12FvT3NfhzzgL1lyj3T97hGt62tHv0vTHdUjBCpXQDYCarV0H61328p
         fxxkSNdTxs5LNOhQ28x5wlI7il60Qxl+fIZ37jBl7H09uebLTe8crK1V8fF3Ww0G07zl
         OOCToHA1dkL3EgwJf2Tww9NqaabawZMJ4MDVYDLUDHxkFwotOc2Q1+JhBL+KrGdPYuv2
         Gm7m5o/7oaro+tYfN8lKYJ8tc9XRlgi+nPVmhE9JS0WCtR8MMxvt8NzPU7fO78DsBdol
         h5Hg==
X-Forwarded-Encrypted: i=1; AJvYcCUlRyYC9yWQkQDRT05nWTcB+MGbbmV8bomp26FRMDLzeWQwUQGbcljNbGKEZoka5nCHAlfNjfag/0szontKjhl1XdTKeJj4YVNrlh02Uw==
X-Gm-Message-State: AOJu0Ywwyo8At9G/lKvnGjyOkCc3B/E3VIG3w9nU+Kc74dZDIcvluwOV
	UAmH9QTolEcfbpzl5SnAPAODyYM1E2HxOnhnNd4CeclTYNnTxrDo/xy5c4dLmurxFmbo9LkOkAy
	TgYNeeYQXgkDVpwNn+X6GA9cTKBCLrQpoUD4Zu7OuecAHWMdkF0M=
X-Google-Smtp-Source: AGHT+IE+776/I97VJo1iquiMi/Yw2Zf4q5ChRdOsvC6Wn8oeSttS7ENd+orAmozSW0Y0YeHPwc8Ri+zGLINvPPdC46g=
X-Received: by 2002:a17:906:5a70:b0:a5a:1562:5187 with SMTP id
 a640c23a62f3a-a626512942fmr636424766b.55.1716817868894; Mon, 27 May 2024
 06:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000f6865106191c3e58@google.com>
In-Reply-To: <000000000000f6865106191c3e58@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 May 2024 15:50:57 +0200
Message-ID: <CAJfpeguD5jSUd=fLaAGzuYU-01cKjSij6UbQWy72LDpqK1KQfw@mail.gmail.com>
Subject: Re: [syzbot] [btrfs?] [overlayfs?] possible deadlock in ovl_copy_up_flags
To: syzbot <syzbot+85e58cdf5b3136471d4b@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, brauner@kernel.org, clm@fb.com, dsterba@suse.com, 
	jack@suse.cz, josef@toxicpanda.com, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, mszeredi@redhat.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git
 f74ee925761ead1a07a5e42e1cb1f2d59ab75b8c
