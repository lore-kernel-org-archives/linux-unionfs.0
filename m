Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDACCD8CAC
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 17:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjJJRe7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjJJRe6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 13:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F214794
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 10:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696959251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjoPN/YgsgIMk+r7qAfo1rYLfnL8kYqBrgyP8Eg8OOM=;
        b=DBGzOpQ7JmhZG2i2SJn1rrziKtJ2qmZsCo0WwbrYApCvfVaRKLvtJzqNuNAnWvB1o/Igl5
        xYJDseJZoIDM8lgl9wh+J76qdNti4srZqa4hKLiw8oK4BjBH3fmAMEmi9prGmGF4hAkWtb
        On9pgPCbYr9Ws7UZCQ4UP2eASpMDvrs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-Fb-PZ-UCMQ6B0F65ndCPLA-1; Tue, 10 Oct 2023 13:33:54 -0400
X-MC-Unique: Fb-PZ-UCMQ6B0F65ndCPLA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bfeaf8cc4bso51341761fa.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 10:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696959233; x=1697564033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjoPN/YgsgIMk+r7qAfo1rYLfnL8kYqBrgyP8Eg8OOM=;
        b=r0l3xDFoEQHLKP98ObS8sxDxj3EE/PkS9XH6KSHdLz5NdMGXwSj0dENYP0oefxBpR/
         DBy+20rvqIfx1vF4PBVECRN4BJnCTrkXXafpUh6mcLoVlefmIhMPDIfx4nST/GMIKrhj
         c1kv5TeFozjAF2Fu7a++zmMIMX2UBzIdGr3A2XR4T/DcCaioYpXWFOlwblAjMDgsOwdr
         8nyim4arThFLXFip4/CSt9rgbiUzxD2F0FdSVeUv8k2IlSub0epizcEOTc420We2gg+G
         /sN1821B5Otgz7K6LPSumrR+3MEozEvfjhsPDPDiAR+EKyKpTTfcGrrheRtwj5PzN2gf
         1jsQ==
X-Gm-Message-State: AOJu0Yxxs2muFmhGjqcy5aZciFcHjQ8sDkNr+3gBR854g34fn/VwCR/9
        RU+Fd7Qjoh606n0Dk/ZgPzDLtXL/i7CjH2rfKhn25HMbIFcI1rELUuBZ6AzDVDpEVpdP6rmZdKf
        tLhLiMlKKbxc5Bb8uMihCKca1nfP9ZbN6YvNBjudbhg==
X-Received: by 2002:a2e:3a10:0:b0:2bc:bd41:ab7c with SMTP id h16-20020a2e3a10000000b002bcbd41ab7cmr14747208lja.53.1696959233359;
        Tue, 10 Oct 2023 10:33:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHO/aGC5d/FW6XWr94YPRqaxKCW/yIDfsw1zOji/+d5eKeGifEXc498I9OqiG9V3szv7JnBEaYGdX8DmUlo9O8=
X-Received: by 2002:a2e:3a10:0:b0:2bc:bd41:ab7c with SMTP id
 h16-20020a2e3a10000000b002bcbd41ab7cmr14747195lja.53.1696959232992; Tue, 10
 Oct 2023 10:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com> <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
In-Reply-To: <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
From:   Sebastian Wick <sebastian.wick@redhat.com>
Date:   Tue, 10 Oct 2023 19:33:42 +0200
Message-ID: <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 10, 2023 at 6:54=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Oct 10, 2023 at 7:13=E2=80=AFPM Sebastian Wick
> <sebastian.wick@redhat.com> wrote:
> >
> > On Tue, Oct 10, 2023 at 12:00=E2=80=AFPM Amir Goldstein <amir73il@gmail=
.com> wrote:
> > >
> > > On Tue, Oct 10, 2023 at 12:06=E2=80=AFPM Miklos Szeredi <miklos@szere=
di.hu> wrote:
> > > >
> > > > On Fri, 6 Oct 2023 at 19:21, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> > > > >
> > > > > On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson
> > > >
> > > > > > And there is the escaping that needs to happen for ':' and '\' =
when
> > > > > > parsing the path parameters (':' is only special syntax in lowe=
rdir, but
> > > > > > the escaping logic seems to apply to upperdir and workdir as we=
ll, based
> > > > > > on my testing). Even using the new API, this is handled in the =
kernel.
> > > > > > We'd like to know if this escaping can be considered stable as =
well, and I
> > > > > > don't think that's a question for the libmount maintainer.
> > > > >
> > > > > Agree.
> > > > > Unlike the comma separated parameters list,
> > > > > upperdir,workdir,lowerdir are overlayfs specific format.
> > > > >
> > > > > ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
> > > > > as does ovl_parse_param_split_lowerdirs().
> > > > > Not sure why this was needed for upperdir/workdir, but it It has
> > > > > been this way for a long time.
> > > > > I see no reason for it to change in the future.
> > > >
> > > > Unescaping  upperdir/workdir was the side effect of using a common
> > > > helper; it wasn't intentional, I think.  The problem is that
> > > > unescaping breaks code that doesn't expect it, and filenames with
> > > > backslashes (and especially \\ or \: sequences) are very rare, so t=
his
> > > > won't show up in testing.
> > > >
> > > > At this point I'm not sure which is more likely to cause bugs: gett=
ing
> > > > rid of unescaping or leaving it alone.
> > >
> > > Considering the fact that the applications that mount overlayfs has
> > > always had to do the correct escaping, getting rid of escaping can
> > > only solve issues in new deployments, so I think we should greatly
> > > favor leaving it alone.
> >
> > Any change here is a regression. I'm seriously confused why this is
> > even debated. You already managed to have a regression and I'm still
> > of the opinion that this should be fixed because it literally breaks
> > user space.
> >
>
> You are right. Literally it does.
> But if prospect users are ok with upgrading libmount and if that
> solves the problem, I'd rather not have to carry in the kernel
> baggage code to support old mount API for a very niche use case.
>
> > > >
> > > > One way out of this mess is to create explicit _unesc versions of t=
hese options.
> > > >
> > >
> > > I like that solution, with two reservations:
> > > 1. IMO, new _unesc versions should only be supported from new mount A=
PI
> > > 2. I only want to do that if real users exists - said users are expec=
ted
> > >     to send the patch and explain their use case
> >
> > This is confusing me a lot. Why would you not want to provide an API
> > which is clearly, objectively the better API? As user space, when we
> > can use the new mount API and we could use this, we absolutely would
> > use this.
>
> I am also confused by this reaction.
> Who said that I do not want to provide the _unenc API?
>
> IIUC, you are requesting a new feature that did not exist before,
> namely, upperdir_unenc, workdir_unenc, lowerdir_unenc options.
> Did I understand correctly?
> If that is the case then please send a patch to support
> those new options in the new mount API only
> including documentation and tests.

My entire problem is that you break user space. Either fix the
regression and *continue* fixing regressions instead of hoping that no
one complains enough and escalates things, or give us another API
where you can actually make that guarantee. The current way is simply
not workable.

Even if we'd accept this regression (and thus regress our user space
to not handle any paths any more), the commitment to keeping the API
stable in this thread has been "we'll try" instead of a "yes,
absolutely" and that makes me worry as well.

> Thanks,
> Amir.
>

