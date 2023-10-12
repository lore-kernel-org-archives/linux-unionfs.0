Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DD7CDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 18:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379652AbjJLSIu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 14:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441906AbjJLSIr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 14:08:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35332CA
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 11:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697134070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijriMX376aLFnN5Oru4L/gj+DiDeJnI73Q159DDW8MA=;
        b=jGQmBz19/iBhgWNUtARUeAu5oxpjWYGMAvC2KgvKiZlMPfflF9KP/NXfpXIRNj2FDCqUaT
        f/fBY5uxQnF3nRDsBetdJYPmv8GOOcA/I/tag3mimO/Ig6NfVGoiOpWitiSeNp4QBGGvXU
        7zRotyPfBvdSod2sH5PV8F+bX57Xd4g=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-KAD-UyRvOPSoHtKGbES4TA-1; Thu, 12 Oct 2023 14:07:31 -0400
X-MC-Unique: KAD-UyRvOPSoHtKGbES4TA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5079630993dso475721e87.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 11:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697134045; x=1697738845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ijriMX376aLFnN5Oru4L/gj+DiDeJnI73Q159DDW8MA=;
        b=rEICtz73hiC/ts8ts+KV5p161JFpomsa7LJgMdB0i3cXVi0tnlT0upTsBn2mk4h8sx
         bTb446ZHClGMWVEQnBl8XCKM89eHahq07KyLHW9X7k681Roh/g5UXNNKm+AVT0YRGkka
         8EBKV9mhSdJ1RgiqgS6UCATVj5rr8VpIO6csRaSINVhWxmdcg016a7OR6OyyOeWMeKd6
         7jdtz8DIbHvnfWYz9VhfLp+4E8C0TulbIG254H1Zx6eKBSR7lYnoe238Vqn4gg3U/blD
         NqwhsrAyob5Xb8ZXINiEBv0oDafrUk4zNswb7xCWa/OuN9/L8FrPUaBxO0o4cXxdNcBj
         0VLw==
X-Gm-Message-State: AOJu0YzcwzFoJZD4zhpJ/2s/f/JLjHMa97QhMwvD/E1YeliuuzGZbsvN
        3RdrN5zmChV4NEN99ZVSmMTpAxx0kdqv8UX+uXDuCO/BAHeltpDMJhrEruq/da8rmak2CFGEL6T
        hoWFoFkGKet8vWlKE+c4kUC1v4a4LERFNHcx/374scQ==
X-Received: by 2002:a05:6512:1391:b0:503:17fd:76bb with SMTP id fc17-20020a056512139100b0050317fd76bbmr26307469lfb.39.1697134045404;
        Thu, 12 Oct 2023 11:07:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSVYn/tnN5VPfU4XU9Hyuqu3zV14niZuoRlCOgixKsQE+XSQm3f3DgEXgEL6zDELDvLs5gN4/6WztrPKUWZk4=
X-Received: by 2002:a05:6512:1391:b0:503:17fd:76bb with SMTP id
 fc17-20020a056512139100b0050317fd76bbmr26307456lfb.39.1697134045047; Thu, 12
 Oct 2023 11:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
 <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
 <20231012-klaut-dohle-e87948620243@brauner> <CAOQ4uxhU4kh5j55RpvD7=vkagySTbbvc=CqLv6sxk5114k4Kvg@mail.gmail.com>
 <20231012-bekam-beneiden-eafffa72ab2b@brauner> <CAOQ4uxi4dLuJeYZ7p-AGRq543ijXXL0p=V-MdKshW5gQHaAWBw@mail.gmail.com>
In-Reply-To: <CAOQ4uxi4dLuJeYZ7p-AGRq543ijXXL0p=V-MdKshW5gQHaAWBw@mail.gmail.com>
From:   Sebastian Wick <sebastian.wick@redhat.com>
Date:   Thu, 12 Oct 2023 20:07:13 +0200
Message-ID: <CA+hFU4xwgqeVwyQPnKSfX76xvNtgwzHHeDjfc1+4=5B8qskiWg@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Sorry if my previous mail sounded hostile. I was just really confused
why a regression wasn't taken seriously.

Thank you very much for fixing it!

On Thu, Oct 12, 2023 at 3:55=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Oct 12, 2023 at 12:49=E2=80=AFPM Christian Brauner <brauner@kerne=
l.org> wrote:
> >
> > On Thu, Oct 12, 2023 at 12:27:26PM +0300, Amir Goldstein wrote:
> > > On Thu, Oct 12, 2023 at 11:26=E2=80=AFAM Christian Brauner <brauner@k=
ernel.org> wrote:
> > > >
> > > > > > Christian,
> > > > > >
> > > > > > Do you know any userspace that already uses your new append pre=
fixes?
> > > > > > Do we have any good reason to support "lowerdir_first"
> > > > > > so a lower dir stack could be reset before creating the sb?
> > > > >
> > > > > If that is a requirement, I suggest extending fsconfig(2) to allo=
w
> > > > > resetting an option.
> > > >
> > > > Overlayfs does already support this. If you pass:
> > > > fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", ...)
> > > > then the lower layer stack is reset. I've implemented it that way i=
n
> > > > ovl_parse_param_lowerdir().
> > > >
> > >
> > > Yes, I noticed that. Cool.
> > >
> > > > >
> > > > > > > > > >
> > > > > > > > > > Anyway, let's focus on what you would like best.
> > > > > > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API=
, I think we can
> > > > > > > > > > find a volunteer to write it up.
> > > > >
> > > > > Can't the existing option names be overloaded if a separate cmd
> > > > > (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfi=
g()?
> > > >
> > > > Yes, they can and filesystems do do that today depending on whether=
 they
> > > > want to e.g., take an fd or a path or something.
> > >
> > > Nice. It seems like Miklos has volunteered to implement the
> > > dirfd and/or unescaped API variants for the new mount API :)
> > >
> > > What is your opinion about the original regression report
> > > regarding escaping of commas in ->parse_monolithic()?
> > >
> > > It's easy to implement ovl_parse_monolithic() that will
> > > conform to the old ovl_next_opt() behavior, but it does not
> > > solve the problem long term.
> > >
> > > If there are currently setups in the wild that pass arguments
> > > like [lowerdir=3D/tmp/a\,b/], even if I do fix up ovl_parse_monolithi=
c()
> > > those setups will regress when they upgrade to libmount v2.39,
> > > because AFAICT, libmount does not respect "\," to escape option split=
,
> > > it respects [lowerdir=3D"/tmp/a,b/"] to escape option split.
> >
> > For full backward compatibility we would probably need to fix both the
> > kernel and libmount. Because libmount/mount(8) is encouraged to split a
> > lowerdir=3D/a:/b:/c:/d option into separate fsconfig calls, especially
> > when dealing with really long paths. So libmount would need to be aware
> > of overlayfs parsing behavior that includes escaping \, even if we fix
> > the kernel itself.
> >
> > I don't think that would be a big deal because libmount already has to
> > deal with all kinds of filesystems specific quirks.
> >
> > However, libmount also added LIBMOUNT_FORCE_MOUNT2=3D{always,never,auto=
}
> > which can be used to disable using the new mount api and makes it use
> > the old mount api which is available in libmount 2.39.
> >
> > So I think complementing overlayfs with a ->parse_monolithic() option
> > might be something that we could consider doing but this is a judgement
> > call there's not clear right and wrong with so many moving parts...
> >
>
> OK. it was quite simple so I posted the regression fix.
>
> > >
> > > If we do decide that we need to or want to fix ->parse_monolithic()
> > > then do you think it would make sense to respect "\," escaping in
> > > generic_parse_monolithic()?
> > > I cannot imagine any workload that would get regressed by this
> > > (famous last words).
> >
> > I'm pretty sure that this would break something so I would be hesitant
> > doing this.
>
> OK. Instead of changing generic_parse_monolithic() I re-factored it:
>
> https://lore.kernel.org/linux-unionfs/20231012134428.1874373-1-amir73il@g=
mail.com/
>
> This may end up being useful for other fs.
> If you agree with the new helper, please ACK and I will send it for 6.6-r=
c6
> along with the two fixes I have on ovl-fixes.
>
> Also updated the xfstest to test escaped commas:
>
> https://github.com/amir73il/xfstests/commits/overlayfs-devel
>
> Thanks,
> Amir.
>

