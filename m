Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA177C54FB9
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Nov 2023 12:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345150AbjKPMH3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 07:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344985AbjKPMH1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2023 07:07:27 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7B1187;
        Thu, 16 Nov 2023 04:07:24 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6cd09f51fe0so413506a34.1;
        Thu, 16 Nov 2023 04:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700136443; x=1700741243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2t4pA4Hy4IcnjOyjoQQ8X1tZCzpmRXP54dZ3bMlYETI=;
        b=iTFhc144TUiq5fR5t6LfDm9jFDYql+S2UdudARg+dB/m9YbYHXLOQxj7GV9SEDJ5HB
         ABheFmx05i2f7hKfYxyts4max7CYrj+xPjXyujRFln9UhG+dGcClt+B0G7ooRvRwcoo2
         rrGulgcIOLq8MG6vKJcfQw2GEJXbkTc4YiIiMTmiWQY98blhOeBHmGZ7+LhoHtwvp+ak
         QVfuchUVU6QExHJNiVNlj0hm3bX4GRb/qvbDzWNkdx4+AsAdan3uIsUBdyKNWHJ2XK51
         lTevSnJH7F4ckoEpZ/dwss2yrohsRdoQiaVlnXaf1jd0vIWGJzIOHcNA8LbHYkY79jR+
         FciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700136443; x=1700741243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2t4pA4Hy4IcnjOyjoQQ8X1tZCzpmRXP54dZ3bMlYETI=;
        b=rQARxN4Vex9HkikmKRVY/n1V5JeQ4GyNwDOCWJs/YGDI5x4ShUFowokyuefFqe0GLG
         NckmWa21R3fyxW9njydMeqU6j6QDSpOkLe4u7+zP3Cnt86h4HnDopwAc9/2Ixrb2qNQc
         +3lGo3gbQOCXpDON/Jiigc/jxM3LEslYDdMhGyEaq9fZaSlcHk1+ptEsJkJd8Jv4tRAz
         BnEZjk3Fbw2oa7JohBPaZSLJX2j4HZrdDDtgMPqEZJpNk8m4HwxPPeQpIuuNsxY06k0L
         Mebu9j0MarqW5i2ATHviPLLjf7EVb5fmwMdBJJacEL+TdVUQ2XJPbR0srhMscGRByn5a
         wmcg==
X-Gm-Message-State: AOJu0YxldNYDIhN2OXy5scNAPT25kn4NCPEDwU+UHXsRWsJ63TT7lB+d
        5Zl2rF13ybTaY+Pe1mdFjsrdJ2+mAqZr6agavWjKApxXg6Q=
X-Google-Smtp-Source: AGHT+IESaJIDsPOMgQHv8Jy+U9ph0GUxIB+r9V/fSnu6doNeWEq4/54ruPF4WHO6e2wIBeM3R8vJOX2dHE4frrVYA5E=
X-Received: by 2002:a05:6830:448b:b0:6d3:1982:6f49 with SMTP id
 r11-20020a056830448b00b006d319826f49mr10224503otv.6.1700136443598; Thu, 16
 Nov 2023 04:07:23 -0800 (PST)
MIME-Version: 1.0
References: <20231112080242.1492842-1-amir73il@gmail.com> <20231116075250.ntopaswush4sn2qf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231116075250.ntopaswush4sn2qf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Nov 2023 14:07:12 +0200
Message-ID: <CAOQ4uxi4VnZDVHkXp-GYff5iT=c+7znZTKR-w-OaM=fn45yNKQ@mail.gmail.com>
Subject: Re: [PATCH] overlay/026: Fix test expectation for newer kernels
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Nov 16, 2023 at 9:52=E2=80=AFAM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Sun, Nov 12, 2023 at 10:02:42AM +0200, Amir Goldstein wrote:
> > From: Alexander Larsson <alexl@redhat.com>
> >
> > We now support xattr of overlayfs.* xattrs, so check that either
> > both set and get work, or neither.
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > This test is failing since overlayfs merge for v6.7-rc1, because it
> > encodes an expectation that set/get of private overlay.* xattrs
> > should fail.
> >
> > This expectation is no longer correct for new kernel, so Alex has
> > fixed the test to expect consistent behavior of set/get of private
> > overlay.* xattrs.
> >
> > We have some new tests for features merged for v6.7-rc1, but this fix
> > has higher priority, so sending it early.
> >
> > Thanks,
> > Amir.
> >
> >
> >  tests/overlay/026     | 35 +++++++++++++++++++++++++----------
> >  tests/overlay/026.out |  2 --
> >  2 files changed, 25 insertions(+), 12 deletions(-)
> >
> > diff --git a/tests/overlay/026 b/tests/overlay/026
> > index 77030d20..f71b3f13 100755
> > --- a/tests/overlay/026
> > +++ b/tests/overlay/026
> > @@ -57,21 +57,36 @@ $SETFATTR_PROG -n "trusted.overlayfsrz" -v "n" \
> >  _getfattr --absolute-names -n "trusted.overlayfsrz" \
> >    $SCRATCH_MNT/testf0 2>&1 | _filter_scratch
> >
> > -# {s,g}etfattr of "trusted.overlay.xxx" should fail.
> > +# {s,g}etfattr of "trusted.overlay.xxx" fail on older kernels
> >  # The errno returned varies among kernel versions,
> > -#            v4.3/7   v4.8-rc1    v4.8       v4.10
> > -# setfattr  not perm  not perm   not perm   not supp
> > -# getfattr  no attr   no attr    not perm   not supp
> > +#            v4.3/7   v4.8-rc1    v4.8       v4.10     v6.7
> > +# setfattr  not perm  not perm   not perm   not supp  ok
> > +# getfattr  no attr   no attr    not perm   not supp  ok
> >  #
> > -# Consider "Operation not {supported,permitted}" pass.
> > +# Consider both "Operation not {supported,permitted}" and
> > +# "No such attribute" as pass for getattr to support all kernel
> > +# version. However, the setfattr result must match getattr.
> >  #
> > -$SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
> > -  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
> > -  sed -e 's/permitted/supported/g'
> >
> > -_getfattr --absolute-names -n "trusted.overlay.fsz" \
> > +getres=3D$(_getfattr --absolute-names -n "trusted.overlay.fsz" \
> > +  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch)
>
> Can we have a helper in common/overlay to check if current FSTYP supports
> get or set overlay.* xattr, to deal with this patch?
>

I see that Alex has already created _require_scratch_overlay_xattr_escapes(=
)
in the patch adding test overlay/084 that I posted.

Alex,

Can you pls refactor that into _check_scratch_overlay_xattr_escapes()
and use it in this patch?

Thanks,
Amir.
