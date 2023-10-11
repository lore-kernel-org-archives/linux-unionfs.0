Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28A5CD8C9F
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 08:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjJKIpV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 04:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345702AbjJKIpP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 04:45:15 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3334A112
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 01:45:06 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 71dfb90a1353d-49d0ae5eb7bso2494667e0c.0
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 01:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697013905; x=1697618705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ul7MgSwCN2e+t+I9zH+WfnPPpEpI+v7Uy0SlIgyM/Pk=;
        b=TL+uYCRUwAg5GNfJpNDxgszIQPrscjOaJ0GGcMC1lleKqR/Mh4K/kk+IIB3+FfrHLH
         bInj3wlZDVgP2yvaBvw6ymnz8UEUswUgJ5adPRbdKysx3NehhCiVj907xz7s59McvZQe
         Whaim/Chy0Y0Mv2TpFMKSxt2Ov2nBHDcykteZWsn/43TAUjuZjy9kKI2PVlMDxrd3SmC
         sdkd87zlT3LVqZhnxcw9JZUH4Vhk9zCzHN/OwJFwEds+GnnNn4/wlyXBzQkRCTTBXmfa
         07v36IFyn/TegEM4yH9hDHuk+dsr51tg12mnvfCLfLoWaWxqsQXFmjKROEpXZeatDOXT
         7d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697013905; x=1697618705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ul7MgSwCN2e+t+I9zH+WfnPPpEpI+v7Uy0SlIgyM/Pk=;
        b=oGL9O0cjGS3Jr2dwrvKPiuKHOVI3AP+6Oy9iRGhuz/bxSPb8Uh62n5eTb7m70V74FI
         39214R592RpnHHO8+fFIg3AXLnz8SSHkb3Kre2VA2oSR1XcPHRDOGF6k7AADHChnfv5d
         eJYFxSLxkrg0HnBpDbvO7GTm7ViQ1nxO1Fd9JDrvWTCeBjyIH/9NJstC1DTe11zXdAfF
         qsWQAtGtgsoHz6Xr+TUe0qC1xKx8YBtB3PS0YEboarJ2bF5w3Q0w/FZW9H23JaWbLR+s
         y58MqBgUc/frGOwtvTf+Mi19MQ7tKL0JPOrU01NLKc3jDk+kCz6hLiVrXk83yU/W+eSV
         j6MA==
X-Gm-Message-State: AOJu0YyIjT1GXPGuvHGbinmmISf84FGy7Cxv97tu2N74SwQYVFFgqCM0
        W35ycsGyDmW4Wc40MgeTLq1O7daD2efxxaKq2ss=
X-Google-Smtp-Source: AGHT+IGTMi/D9SPA9deOtAbNMVkY+X4W8tUbYpuxO8hPenRc6DmcXjlkCJI6RRf0ocWwMrLdFyJD9M8309MbSru8IDI=
X-Received: by 2002:a05:6122:2907:b0:49d:d0af:771a with SMTP id
 fm7-20020a056122290700b0049dd0af771amr15742471vkb.6.1697013905081; Wed, 11
 Oct 2023 01:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com> <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
In-Reply-To: <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 11 Oct 2023 11:44:53 +0300
Message-ID: <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 10, 2023 at 9:33=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 10 Oct 2023 at 20:15, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > It may not be me, it may be someone else, so there is a limit to my
> > commitment, but kernel developers usually abide by Linus' no regression=
s
> > rules (which do allow some slack).
>
> Note: the no regressions rule is about actual "out in the field"
> regressions, not about potential or theoretical regressions.
>
> My guess is that changing the escaping rules for workdir and upperdir
> would not make any difference.  Look: on my laptop 0.0032% of
> filenames contain a backslash.  How likely is such a filename to be
> used as workdir or upperdir?  So yes, I think getting rid of
> unescaping for these parameters on the new API is safe and will not
> invoke the no regressions rule.
>
> The same cannot be said of lowerdir, because the incidence of colons
> in filenames is much higher.  But the new API also introduced an
> "append mode" for lowerdirs, where the colon doesn't have the same
> separator role as with the "bulk mode".   Unfortunately it's not
> possible to clearly differentiate the two modes, which I think is a
> downside of the current design, and it's why I suggested the _noesc
> variants.
>

We could add new keys:
lowerdir_first=3D,lowerdir_next=3D,lowerdatadir_next=3D
as explicit variants for the "[^:]",":","::" prefix detection
and those don't need to be unescaped.

> >
> > Anyway, let's focus on what you would like best.
> > If you prefer to just fix the regression, it is doable.
> > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
> > find a volunteer to write it up.
>
> It's not all good: when showing these options, the result is
> completely meaningless.   Or is there a plan to make that work nicely?
>

Currently, the paths to display in mount options are stored
in ofs->config.lowerdirs array.

Those paths could be invalid or point to different objects or not
accessible from the mount namepsace by the time someone
observes them in mount options, so there are not many guarantees
about those displayed paths.

We could use file_path() to resolve path strings of the moment in the
mount namepsace of the mounter from the lowerdirfd files and store
them in ofs->config.lowerdirs array.

I don't think it matters that the displayed mount options are not the
actual user passed mount options as long as the paths are fairly
descriptive and as long as they can be use to mount the same overlay
with the same mount options in the common case (no escaped chars).

BTW, it looks like we also don't display the user passed lowerdir
parameter as is in the case of escaped characters in lowerdirs.
Admittedly, that is another change of behavior from the new mount
api param parsers.

Thanks,
Amir.
