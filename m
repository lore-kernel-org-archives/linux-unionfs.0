From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH][V3] ovl: fix lookup failure on multi lower squashfs
Date: Wed, 13 Nov 2019 21:29:05 +0200
Message-ID: <CAOQ4uxjrON7FvEgOUvKP8DoHfbVY+LxinTMa=uAeHwAp=--zuw@mail.gmail.com>
References: <20191113175746.110933-1-colin.king@canonical.com>
 <CAOQ4uxiV06H9s8WMso6A1A7mhdvQ_AuWM0n71VoGYTdryi8KNA@mail.gmail.com> <a494f07f-c1e3-a9e3-2af5-252d59df4bfd@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a494f07f-c1e3-a9e3-2af5-252d59df4bfd@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

> > Sorry I wasn't clear.
> > Miklos is right. the test ofs->upper_mnt here is bogus because
> > nfs_export could be enabled without upper.
> > The change you made in v3 to ovl_lower_uuid_ok() should be enough.
>
> OK, so the following is required for V4:
>
> +       if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
>

Yes. more accurately there should be no change to this line.

Thanks,
Amir.
