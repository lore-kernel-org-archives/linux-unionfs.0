Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C0FCDB482
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 13:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbjJLNzM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjJLNzL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 09:55:11 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A93D91
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 06:55:10 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-d9abc069c8bso901593276.3
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 06:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697118909; x=1697723709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1YCvj8h2W8pFNP9Kus0h1X/Rdk7Lo0KQD7sZjLNnhs=;
        b=gWJb2zGq2+zxRVcg8s0NY1u2u0EqFfbBQExBHjUjAI+TuPCX85gOumlipfjANRBAbd
         nywBRNnqVN7eri4f8efDdNuJx504r9lbbNL1TbYXjxSpTfi1oNWsa6pqpK0sbrcvR3qW
         n7w2Y4992vEChsYZgc24uZ9aSgM35XiwRVY8mjA94wh2NX5dwSXtugSL29GQuRcTUwn7
         1Jnvs9QWD+JkVQpz+iS8Qhtv2/Y/hAXtaz/gWL2r1Uvs+3ayhjj/uC8kKGZFOQUVrgbi
         DsjMaGFcTERaxGcpvHxVX8s2j8ZkeZbXYl68adtVhTc0jdcO1vKcyN4foa2dSoiub9fG
         SE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697118909; x=1697723709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1YCvj8h2W8pFNP9Kus0h1X/Rdk7Lo0KQD7sZjLNnhs=;
        b=kDVwCXxsIgO6sn3uzUIbL6nSCzb3KKpEqZUEykSEXWOcpZmKml33P9YeZZALatGvle
         EvYeFBhQ8n2/ifsKmDgF4PRzPbb/MVVdEPjPN0J3cVaAoYzyEjtr7A1fSYCcWde0uksb
         LQrs+7wr27rlOsAgytPea1HixSvrLZZv7JneN0q8uimwf6Qyzb0X2OKT9u4Co3CtbK66
         83aGLckMSPV+4ubSLWNiA2ZxYQqmQN0ZSxPCIpptv/MXn7nOe2BhjZs5g6FDuKyAVrJz
         6bPBj+gXIG7s3A21xHgP/kvIYY8DbobD/78f1Au51vYXjYahTKxM0l7b14PyQnbVyycE
         fhpQ==
X-Gm-Message-State: AOJu0YzZoZizKXgvIuBsD7RshZNnI6gnsO6Jsg0YR9tBhD01zwPxO3mb
        f/ik9MxVaR6sfVCLlbh4y1JlNUwZZkiTXi5pkaZ+QpVJBfg=
X-Google-Smtp-Source: AGHT+IFTXMU91ASw4US7NvpA/MpOvdPabKC9zBYtUd8T0x1XuL8SRSpLtr/CfeFM2PVg7zKM+w6u2SAVp2ISN5Z/rR0=
X-Received: by 2002:a25:5503:0:b0:d91:c488:5b65 with SMTP id
 j3-20020a255503000000b00d91c4885b65mr17218001ybb.31.1697118909122; Thu, 12
 Oct 2023 06:55:09 -0700 (PDT)
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
 <20231012-bekam-beneiden-eafffa72ab2b@brauner>
In-Reply-To: <20231012-bekam-beneiden-eafffa72ab2b@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 12 Oct 2023 16:54:57 +0300
Message-ID: <CAOQ4uxi4dLuJeYZ7p-AGRq543ijXXL0p=V-MdKshW5gQHaAWBw@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 12, 2023 at 12:49=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Thu, Oct 12, 2023 at 12:27:26PM +0300, Amir Goldstein wrote:
> > On Thu, Oct 12, 2023 at 11:26=E2=80=AFAM Christian Brauner <brauner@ker=
nel.org> wrote:
> > >
> > > > > Christian,
> > > > >
> > > > > Do you know any userspace that already uses your new append prefi=
xes?
> > > > > Do we have any good reason to support "lowerdir_first"
> > > > > so a lower dir stack could be reset before creating the sb?
> > > >
> > > > If that is a requirement, I suggest extending fsconfig(2) to allow
> > > > resetting an option.
> > >
> > > Overlayfs does already support this. If you pass:
> > > fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", ...)
> > > then the lower layer stack is reset. I've implemented it that way in
> > > ovl_parse_param_lowerdir().
> > >
> >
> > Yes, I noticed that. Cool.
> >
> > > >
> > > > > > > > >
> > > > > > > > > Anyway, let's focus on what you would like best.
> > > > > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, =
I think we can
> > > > > > > > > find a volunteer to write it up.
> > > >
> > > > Can't the existing option names be overloaded if a separate cmd
> > > > (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig(=
)?
> > >
> > > Yes, they can and filesystems do do that today depending on whether t=
hey
> > > want to e.g., take an fd or a path or something.
> >
> > Nice. It seems like Miklos has volunteered to implement the
> > dirfd and/or unescaped API variants for the new mount API :)
> >
> > What is your opinion about the original regression report
> > regarding escaping of commas in ->parse_monolithic()?
> >
> > It's easy to implement ovl_parse_monolithic() that will
> > conform to the old ovl_next_opt() behavior, but it does not
> > solve the problem long term.
> >
> > If there are currently setups in the wild that pass arguments
> > like [lowerdir=3D/tmp/a\,b/], even if I do fix up ovl_parse_monolithic(=
)
> > those setups will regress when they upgrade to libmount v2.39,
> > because AFAICT, libmount does not respect "\," to escape option split,
> > it respects [lowerdir=3D"/tmp/a,b/"] to escape option split.
>
> For full backward compatibility we would probably need to fix both the
> kernel and libmount. Because libmount/mount(8) is encouraged to split a
> lowerdir=3D/a:/b:/c:/d option into separate fsconfig calls, especially
> when dealing with really long paths. So libmount would need to be aware
> of overlayfs parsing behavior that includes escaping \, even if we fix
> the kernel itself.
>
> I don't think that would be a big deal because libmount already has to
> deal with all kinds of filesystems specific quirks.
>
> However, libmount also added LIBMOUNT_FORCE_MOUNT2=3D{always,never,auto}
> which can be used to disable using the new mount api and makes it use
> the old mount api which is available in libmount 2.39.
>
> So I think complementing overlayfs with a ->parse_monolithic() option
> might be something that we could consider doing but this is a judgement
> call there's not clear right and wrong with so many moving parts...
>

OK. it was quite simple so I posted the regression fix.

> >
> > If we do decide that we need to or want to fix ->parse_monolithic()
> > then do you think it would make sense to respect "\," escaping in
> > generic_parse_monolithic()?
> > I cannot imagine any workload that would get regressed by this
> > (famous last words).
>
> I'm pretty sure that this would break something so I would be hesitant
> doing this.

OK. Instead of changing generic_parse_monolithic() I re-factored it:

https://lore.kernel.org/linux-unionfs/20231012134428.1874373-1-amir73il@gma=
il.com/

This may end up being useful for other fs.
If you agree with the new helper, please ACK and I will send it for 6.6-rc6
along with the two fixes I have on ovl-fixes.

Also updated the xfstest to test escaped commas:

https://github.com/amir73il/xfstests/commits/overlayfs-devel

Thanks,
Amir.
