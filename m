Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E684CD6E60
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 12:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbjJKMHU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbjJKMHO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 08:07:14 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6FC93
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 05:07:13 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-4526c6579afso587544137.0
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 05:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697026032; x=1697630832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3hItJlGYcMHwwvI6O7AU4c6543k2EF2VzT3dOpaMws=;
        b=TP0JzlblVWR8GTmywvIPdpj+67chF3ifEQJT9DtgATAdH0RWTxL7cSMhCSev1jyGrf
         NTKq/jCmLsRGrewUKg1L6zAFo+pzjN97B+1Ne93l07yU9TtC4DJT8aWrsK0lki9IdOHO
         YC1LS6KcEts0/NjzY6oA/F4YgJUAWogsRYgtjXbj5S8p2T/fEM1XPwpk9zy6C5KqiVdj
         nfahEKNMCodmpSCC9a5Vf/M3iFEei7212xHtAvoQzPL7CzR43uNF7lABytvhMgF87fsh
         9tt6cvUnc8hN/x+Q07xY42dLG/tBQuZECdbPHdAijPJ8vBqgO62cjIlnaeZZhd6bZfdI
         8J1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697026032; x=1697630832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G3hItJlGYcMHwwvI6O7AU4c6543k2EF2VzT3dOpaMws=;
        b=JVQv+PElT/EQ171yDysuhehw5eDWS29KDeVCrqc+UuKwDaciM3CzSTsrrrwDGIBK4Z
         b/9VJQk4yOba0DmmhgxQ1s9D0p4n/Wg8mmEldpi2bKe6cx0cMj9RMRcVdzFKcZELQbh/
         ogRB4/+8HgyDD0J9zD8yKeQM54l5OW/PWgfutnyCH2JYmaFmwp2HHvI3FHM1m9AIUSs1
         euh3uNN19evFlO+Jo+97aL1/lXVhVXealfTVCp9kr3k0xyB+R03Kkgik8dFrN85845mx
         dosEsFaCCEM6BPh9/nvgfpMpK+yraLvX0gzc2YekUpobEiaImsfYlDOwEwLz+X/ZyIZ8
         6yog==
X-Gm-Message-State: AOJu0YwyPnH3GnELBtMJvSnbQgy8hv96HEac3Rc1bjXCUmJ2CAFY+NYw
        pfT/nOXJTqQtKDm3pfPQGd0947kPCTlTRfOZncLSPtafSAk=
X-Google-Smtp-Source: AGHT+IHWYVKc2adVIXLAKrQRRamoheQe9P+VRdS8WlduXKnvTBOgaRkWjahms75JVVyPPm3GUilLiKf3uk7RKHJsIbI=
X-Received: by 2002:a0c:f591:0:b0:66d:589:5841 with SMTP id
 k17-20020a0cf591000000b0066d05895841mr2005483qvm.28.1697026021366; Wed, 11
 Oct 2023 05:07:01 -0700 (PDT)
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
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com> <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
In-Reply-To: <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 11 Oct 2023 15:06:49 +0300
Message-ID: <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
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

On Wed, Oct 11, 2023 at 1:18=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 11 Oct 2023 at 10:45, Amir Goldstein <amir73il@gmail.com> wrote:
>
> >
> > We could add new keys:
> > lowerdir_first=3D,lowerdir_next=3D,lowerdatadir_next=3D
> > as explicit variants for the "[^:]",":","::" prefix detection
> > and those don't need to be unescaped.
>
> Good idea.  I'd merge "lowerdir_first" and "lowerdir_next" into
> "lowerdir_one" or whatever for simplicity.  I'd also consider dropping
> the prefix detection, since it has only been in mainline for one
> cycle.
>

OK.

Christian,

Do you know any userspace that already uses your new append prefixes?
Do we have any good reason to support "lowerdir_first"
so a lower dir stack could be reset before creating the sb?

> > > >
> > > > Anyway, let's focus on what you would like best.
> > > > If you prefer to just fix the regression, it is doable.
> > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we=
 can
> > > > find a volunteer to write it up.
> > >
> > > It's not all good: when showing these options, the result is
> > > completely meaningless.   Or is there a plan to make that work nicely=
?
> > >
> >
> > Currently, the paths to display in mount options are stored
> > in ofs->config.lowerdirs array.
> >
> > Those paths could be invalid or point to different objects or not
> > accessible from the mount namepsace by the time someone
> > observes them in mount options, so there are not many guarantees
> > about those displayed paths.
> >
> > We could use file_path() to resolve path strings of the moment in the
> > mount namepsace of the mounter from the lowerdirfd files and store
> > them in ofs->config.lowerdirs array.
>
> Right, so the configuration would use fd's while the display would
> fall back to string paths.  That makes sense.
>

Assuming that using fds is a desired feature regardless, then
possibly the _noesc options are unneeded. Not sure.

> > BTW, it looks like we also don't display the user passed lowerdir
> > parameter as is in the case of escaped characters in lowerdirs.
> > Admittedly, that is another change of behavior from the new mount
> > api param parsers.
>
> And it's a bug (regardless of being a regression or not) since commas
> and whitespace  must be escaped on this interface, and colon too for
> being a separator of lower layers.

OK. I think it should be easy to fix this bug.
I can look into it.

>
> More fun: upperdir and workdir use seq_show_option() which escapes
> commas and whitespace, so any escaped characters during mount will end
> up being double escaped.
>
> Obviously this domain is severely undertested.

This is all very complicated because actual users always
go through escaping rules of bash and libmount.

For example, the output of 'mount' command unescapes the
escaping done by seq_show_option() for /proc/mounts.

That's why it is scary to change the legacy behavior and better
to provide the new unescaped options as you suggested
and leave all the escaping in the future to userspace.

Thanks,
Amir.
