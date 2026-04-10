Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67FE26FA5A
	for <linux-unionfs@vger.kernel.org>; Fri, 10 Apr 2026 11:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820885; cv=pass; b=GHHzsoIMppG/M82LGHi8hSzN55Et1UhvPrM0/pzD576GdjDttc6TVpoHNsGfoKo0cj15yfNRy+SD0RQkQHJkfEatsPIP8o+TVcaBa/E++3sW8CXu6dAUQ43dWb8mB+CukBdwOuURuuFCEprpJm4/QAi+SpEfCD73TvomasVcHFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820885; c=relaxed/simple;
	bh=2p15eTMEFG5LbZTbfvyvyHQRJm3xhc7/w+GP3/gLHjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ClhW+l3cjS/hUSyKh5v1EKhKBIMHl9lxzaQyi8w/gphRZrcKmMi0CqVosVYlIcW2rIuFBSKvVqBIXiRKElhIHOQ3hKvTLVgwBJ6ja/U04d+1s9IR4hVIrmhB4OtvShFexVCvQQFVobJe0RNwsig7GWwbuz8mDg6BsAcNoqf0VyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOxlGRvk; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOxlGRvk"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b9b1ffbb9f5so280383866b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Apr 2026 04:34:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775820882; cv=none;
        d=google.com; s=arc-20240605;
        b=a43S2XO9WlHbmqMQQRxCAB8SH901EpaW8xskzi/XOIGRNxJeiSHlH6rcXojb/WwnPI
         Bhlj/F0M7NKV4vZsrbI2B3J1UT+4Ba6uLmJMVSR1x135z13X8y4rwsI1c3IrwCiuIu0r
         TaKenYEUHNPLigSsofk8E2sjkwTC/oSoWEQFW0qixNp6MWF41KMAkRXH4nnt7X+y2fn7
         kAi1Pfi/gEuyAH8S/HRDtmOARlkmJAM/nL7BssMUlY62obSL7jhtC0p3fPceryyojBYt
         AErhttjaGxiTDSxaZP4GOnYD82ReSHO6ath15kUe0DC+TWH0RQZBWNEiRJ5vVfoAeJIJ
         ytqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t/Os5UX8qkAPx4XiFFfVcPBZNLQmrIX0gdgvO9SQghQ=;
        fh=aqn9+8ojnFjJuyOw7BNp5smD3qNqSr4vPf7aSGDpZjQ=;
        b=G2Dh35gfIuj1KjPbPiEAFdbDJyjUIJnVdiofEfNbsP2uKdk+ITyn3VHvZRw+D9+QAV
         74J+wMKRFIfQ+UB3ekjykZ4f05SU1djhvPXaB2dX802UAHzPWn/wjtVjv1I4pVw3Wl40
         TFqAtS9aWLPkcQnbSI7Rd2omJ6QLAdBwOXiyYLW+8o83v1spFKDcyfyabu8aa9wsbisP
         uBQzlARH7+Sn3G3dpIhdNVQefoQ37N43u7ymsy3SO3CBzq+vXggWCt++UO/syLAEEp60
         CgZeOihiBVm58VbQxPyts2fNRpfnctiepv1C5dQXFWKUgI+EHRQO+YEiB0VGy/nJIa+f
         YTVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775820882; x=1776425682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/Os5UX8qkAPx4XiFFfVcPBZNLQmrIX0gdgvO9SQghQ=;
        b=AOxlGRvkNIlpLvgddBF7CzEKNISaCJuTyE6CZJenNJUvwDifRv8ft7hunpAEHd4Duv
         QMqtTdKjAm+guLCYUrUZ6qj08KqFeXmg1WEJDCg2e222ykgD67ZerTbwrtYWJpKRBX+X
         ygFoAIc927WilKhMyLR2JCDY18ojXUVF2vDHuKHVNXicQwmCvvw8xockcBtaAJIAT8CV
         El3xjZccGFz+YVbH1Y6Zavq/YkdC9qVrScf34I2ys4tyetPlxFkPVnbizww/X4JtfaEH
         nH5dkXrBWwTcFEQ0YO0yOqr2C6I5NXMRn71AbJ1Ut/O+X/3UAg5sIw/D18qhjK0UlkVj
         6jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775820882; x=1776425682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t/Os5UX8qkAPx4XiFFfVcPBZNLQmrIX0gdgvO9SQghQ=;
        b=Jy/GXGQZkj/ipkeHx3cvw8lopfSTMv8Aie1UoBEZr1RxeUuxypkrF9YUDxLrlnBy3T
         HRkuDb7OgQTBzI2Hfyh1dEZB4sYU2KgSLT9haBNCXcINFsEyCVzSAX3SqywIDJ5QKOVo
         EV4zgnZ2dvlPug9HDfw29CX/oh07TZr1KLTmcVAG5xKP7ETQwTcJxbfZp1YLX/N+uYWA
         ygDwRoX/zi9dyP02oLppFAiPuhV6b3zdFA/lpeA8CqXs67a5+MjxkT7K4lzbd5NhdEiP
         wogbK9ampY2CsR/REO+KVaDELAbRSTXAzRWIi4D+MqnrHipgb3h+L2JyzSTjdWE9po8s
         kFzA==
X-Gm-Message-State: AOJu0Yy5J1UjxGKqPMCqBiZ1EKohMcIHU8a++RcW0ETk8KQ+afi35H88
	BCZyzf1GuobCVmvioF7GV8gFdSFmNR5VTh7x7kbmFpW1bLbXeFY08bxTAw2/BsU+2BrKfLglRqp
	dRszzkRqM6fiCZOjwSBDSDMlWexoQkLpD/yxL78g=
X-Gm-Gg: AeBDievXVWgMafDezHlnTRzPATWQLyYTt1vdymH7iS/pnRXc+6wkdjotqSHomMfC6j3
	UV+PkCos8ALbWZSOQMrxQDHh1EaF7diaB6YqhNPLLuDfqwonlUrPo5oyIKEXJnijOVkC+qkTHdb
	JbDmLLHPgvKEwtNKX7Vwa88+1Kew/L+cHL1BWtsk9WkDqcoydlOeo6LAdke4kf/+A9mlu2YzTMW
	OMaRuXEGADbUopzV+Z+2EYzwMxyFF38xN/AukWe+mh5jMjgSgzQ2OL4RaxZB7h1kA8VW0YR6t/f
	uDeTxMItjI5ZP+ZiVbs/mGpBnAr2L754qoIGMuoCwQ==
X-Received: by 2002:a17:907:e10d:b0:b97:f22f:43c3 with SMTP id
 a640c23a62f3a-b9d7279ae54mr107554466b.31.1775820881816; Fri, 10 Apr 2026
 04:34:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <wtbfe3tb3uk6oeitkqodcal63p7pj6xjqwujzlzglina7o7imr@4sv25le6djgg>
In-Reply-To: <wtbfe3tb3uk6oeitkqodcal63p7pj6xjqwujzlzglina7o7imr@4sv25le6djgg>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 10 Apr 2026 13:34:29 +0200
X-Gm-Features: AQROBzCdR_vvGuOy7WliMnXcrBmo2-nNOI4jGqJBPctfX_e1ZHMuOzXOhwFVH4w
Message-ID: <CAOQ4uxj558yzeFtbVbK-OZ_isWOEJ5fbD2odh4MkA4Od-ga6-A@mail.gmail.com>
Subject: Re: [aalbersh@kernel.org: [PATCH v7 03/22] ovl: use core fsverity
 ensure info interface]
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 1:10=E2=80=AFPM Andrey Albershteyn <aalbersh@redhat=
.com> wrote:
>
> Forgot to add overlayfs as a receiver, this is overlayfs relevant
> patch in the patchset adding fsverity support for XFS [1].
>
> The patchset exposes fsverity_ensure_verity_info() [2] which could be
> used instead.
>
> 1: https://lore.kernel.org/linux-fsdevel/20260409131404.1545834-1-aalbers=
h@kernel.org/T/#t
> 2: https://lore.kernel.org/linux-fsdevel/20260409131404.1545834-1-aalbers=
h@kernel.org/T/#m6baa3210a16a2f54ce977353da7532a93f1aef65
>
> ----- Forwarded message from Andrey Albershteyn <aalbersh@kernel.org> ---=
--
>
> Subject: [PATCH v7 03/22] ovl: use core fsverity ensure info interface
> From: Andrey Albershteyn <aalbersh@kernel.org>
> Date: Thu,  9 Apr 2026 15:13:35 +0200
> To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
>   linux-fsdevel@vger.kernel.org, ebiggers@kernel.org
> Cc: Andrey Albershteyn <aalbersh@kernel.org>, hch@lst.de,
>   linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
>   linux-btrfs@vger.kernel.org, djwong@kernel.org
> Message-ID: <20260409131404.1545834-4-aalbersh@kernel.org>
> In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
>
> fsverity now exposes fsverity_ensure_verity_info() which could be used
> instead of opening file to ensure that fsverity info is loaded and
> attached to inode.
>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks nice

Acked-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/util.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 2ea769f311c3..8bde5dc31d7d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -16,6 +16,7 @@
>  #include <linux/namei.h>
>  #include <linux/ratelimit.h>
>  #include <linux/overflow.h>
> +#include <linux/fsverity.h>
>  #include "overlayfs.h"
>
>  /* Get write access to upper mnt - may fail if upper sb was remounted ro=
 */
> @@ -1377,18 +1378,9 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, c=
onst struct path *path, int pa
>  int ovl_ensure_verity_loaded(const struct path *datapath)
>  {
>         struct inode *inode =3D d_inode(datapath->dentry);
> -       struct file *filp;
>
> -       if (!fsverity_active(inode) && IS_VERITY(inode)) {
> -               /*
> -                * If this inode was not yet opened, the verity info hasn=
't been
> -                * loaded yet, so we need to do that here to force it int=
o memory.
> -                */
> -               filp =3D kernel_file_open(datapath, O_RDONLY, current_cre=
d());
> -               if (IS_ERR(filp))
> -                       return PTR_ERR(filp);
> -               fput(filp);
> -       }
> +       if (fsverity_active(inode))
> +               fsverity_ensure_verity_info(inode);
>
>         return 0;
>  }
> --
> 2.51.2
>
>
>
> ----- End forwarded message -----
>
> --
> - Andrey
>
>
