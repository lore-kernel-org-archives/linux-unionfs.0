Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjWdRf+J"
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365C8D72
	for <linux-unionfs@vger.kernel.org>; Fri, 24 Nov 2023 07:12:33 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-548c6efc020so25538a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Nov 2023 07:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700838751; x=1701443551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=quAfw52oJT3Iu4f4DiSuO7KlI7QjDDj//SV/3y1fuKM=;
        b=jjWdRf+JaAQYJf+lfA+Nh/8IGDDbOvHOe1vRhvRkOyQq16CWk+BPwgPpe5l0zRVjog
         ltzhqba8Ug3LHf0ZXvez8RqUkAZefC8knq2JoX6uGjIT0VY/krpd5wDnmv2tQ1FNEj6I
         4/lgryle1puSCMEEt5yu/i6UIXbld9GSdx1Pna+U2lBJM13NzHZ7Mr8ZAgU4p0rTwU3x
         WL2AIkhxZf5nVmJZy6byLZuFxSIkBdyTIcWgv90kG7p1yNrCKRA10ktZoVRQ8/1pNUul
         XSynh1mtlBuK4i4IdZFxYqOTd8k8qtyt52ifsxPbAGU1cHMXGY7SPkTb5CScsJPmHYv/
         IF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700838751; x=1701443551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=quAfw52oJT3Iu4f4DiSuO7KlI7QjDDj//SV/3y1fuKM=;
        b=T00sJQelfUYfuJQ86wsGpstasu6lWvYJPqZjBGP6B2TWEliCrcmlVEywemDU5lzPdi
         sD4caWNheJPln2WUmKl+yQXWV2kmC5Mouww+NxMBFDxnZyVYzeSOrs1DwembqLnJeCnD
         q0HDaiTKmprQkU+4x+KjT439yputJXxYA9HPNTTWhzdeGie4XUINQmYNuqhYV3zYiITr
         lmaNbrOOg27jGT2yJXl12GMkPyNWBCXZB45rcTjuEe2HmxV79pdZrLBgb/PmIxlRI8bm
         QP6Oj8pWGju93nETZHFsFUwcFB7ZnL5YhBCcLXTPi+NLmKjgqQeRbI596y6YulizVdGx
         259Q==
X-Gm-Message-State: AOJu0Yyhkhdsr+Obwc1mMQN9BQdfMdOyBfTxIGQ4gEjlGGC/AOvVNawg
	bYlx8vJi3RiaJbGDpbUt2PReeDHulJ6DLuCQTWuvLA==
X-Google-Smtp-Source: AGHT+IGr8o2vaGk4g6YM40MXMmczEWY89+5Ocxwtmih7cxA00JkoD3KjvhIVDs7wYG8aG9O+PyZcv4bA2VWF5pkkUBw=
X-Received: by 2002:a05:6402:11c6:b0:54a:ee8b:7a99 with SMTP id
 j6-20020a05640211c600b0054aee8b7a99mr112274edw.0.1700838751574; Fri, 24 Nov
 2023 07:12:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxjssgw1tZrUQvtHHVacSgR9NE0yF8DA3+R5LNFAocCvVQ@mail.gmail.com>
 <000000000000258ac60606589787@google.com>
In-Reply-To: <000000000000258ac60606589787@google.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 24 Nov 2023 16:11:54 +0100
Message-ID: <CAG48ez2UkCR7LMaQfCQVLW4VOZG9CuPDMHG7cBtaAitM=zPBCg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] KASAN: invalid-free in ovl_copy_up_one
To: amir73il@gmail.com, 
	syzbot <syzbot+477d8d8901756d1cbba1@syzkaller.appspotmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2023 at 5:10=E2=80=AFPM syzbot
<syzbot+477d8d8901756d1cbba1@syzkaller.appspotmail.com> wrote:
> syzbot has tested the proposed patch and the reproducer did not trigger a=
ny issue:
>
> Reported-and-tested-by: syzbot+477d8d8901756d1cbba1@syzkaller.appspotmail=
.com
>
> Tested on:
>
> commit:         8e9b46c4 ovl: do not encode lower fh with upper sb_wri..
> git tree:       https://github.com/amir73il/linux.git ovl_want_write
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10d10ffa68000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dbb54ecdfa197f=
132
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D477d8d8901756d1=
cbba1
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for D=
ebian) 2.40

It looks like the fix was submitted without the Reported-by tag, so
syzkaller doesn't recognize that the fix has landed... I'll tell
syzkaller now which commit the fix is supposed to be in, please
correct me if this is wrong:

#syz fix: ovl: do not encode lower fh with upper sb_writers held
