Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686F0C7EE22
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 May 2023 06:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbjEOGNR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 May 2023 02:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjEOGNQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2023 02:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC8599
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 23:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684131151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pdsn3qGgTLeTkiMuKjEiUFNwY2KoFNpZ7qP+V7Kd6v8=;
        b=b/sqnCwjuPfrQTh3lYNYU+H3MI25j24NPzTanHsW9pvhb5sl6+0BiYTmV7LExhF9XIje9K
        zSoDf3+nKj9oVUluB0AAnGBPjEb5EcKWA5RWC5zAwQ54AdgAd7qqWoZ4iYjeFPvpy418qk
        W6x/smJJDI6TrlLPi68dsXrzYCG5qIw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-46oJM7obPOmVqfvyklG-Fg-1; Mon, 15 May 2023 02:12:29 -0400
X-MC-Unique: 46oJM7obPOmVqfvyklG-Fg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33765ca2c69so8224495ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 23:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684131149; x=1686723149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pdsn3qGgTLeTkiMuKjEiUFNwY2KoFNpZ7qP+V7Kd6v8=;
        b=KQfM6OSHPHP32/k/B+ZUJs6OXyzkryCPrjVKyCIiCwk/iT64hC16LQ7UO2Oz9Yc0cB
         G0HKTDVa7RLOv4zReeeqAJ6+bardOYMRt0sZ98kghiECwq0VURTyczB35W96Dr2PSgm7
         cIAHluvbXw7TNLZJ3SsDN4p16ZwjKK5ddktbkLWZYSeApYyC6OtxNuEnqlbigwSUAgyc
         BmXPNAWpvt4vPn35DpoGJ8j6WWyIEGZ1dNkmaTcWmlKrtvms5BO5VC7GgpYgjDhr5k64
         jo7k6OlPRCwWeSoR0my4+ANakDrA1XW6GsEkNMaB/aRSLPYBOfbvm9wYHhd4QYgBAy8H
         rObg==
X-Gm-Message-State: AC+VfDxKkZxBTTahh6z/vzlRCNT5tFaIen/pzuTLhq1KD4BLRt5iOer5
        s1jXmwQY0sXciAQdO2Nsb5Rub6I/Sh14HQzhokWvxxGAzUAooy6LI/9hN6cNNNbcP0VX1QbzN2k
        oCot6fg8V5siQF4YzntO8cenmUwQm8gk5gbZfYcmcog==
X-Received: by 2002:a92:c8c8:0:b0:335:6e5d:afb4 with SMTP id c8-20020a92c8c8000000b003356e5dafb4mr16277203ilq.24.1684131148869;
        Sun, 14 May 2023 23:12:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+SFq2BIIjvc+BvKCs4v8nadIsVzNIBKDXxvlsCxgbNdIFwNtfK1DgaxEPb0dFraJwECzelDL7oVTMKkSFifc=
X-Received: by 2002:a92:c8c8:0:b0:335:6e5d:afb4 with SMTP id
 c8-20020a92c8c8000000b003356e5dafb4mr16277193ilq.24.1684131148691; Sun, 14
 May 2023 23:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain>
In-Reply-To: <20230514191647.GD9528@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 15 May 2023 08:12:17 +0200
Message-ID: <CAL7ro1G8q-n+LYAjD-JDHReM4685+TuR0h9yyGsoN+cXtjabYg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 9:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, May 03, 2023 at 10:51:38AM +0200, Alexander Larsson wrote:
> > When resolving lowerdata (lazily or non-lazily) we check the
> > overlay.verity xattr on the metadata inode, and if set verify that the
> > source lowerdata inode matches it (according to the verity options
> > enabled).
>
> Keep in mind that the lifetime of an inode's fsverity digest is from when=
 it is
> first opened to when the inode is evicted from the inode cache.
>
> If the inode gets evicted from cache and re-instantiated, it could have b=
een
> arbitrarily changed.
>
> Given that, does this verification happen in the right place?  I would ha=
ve
> expected it to happen whenever the file is opened, but it seems you do it=
 when
> the dentry is looked up instead.  Maybe that works too, but I'd appreciat=
e an
> explanation.

The overlayfs inode will, after lookup, keep a reference to the dentry
(and thus inode) of the lower file, until such a time that the overlay
inode is evicted from the cache. This will keep the fsverity digest on
the lower alive while the overlay inode is alive. If the overlay inode
is evicted, then we will re-validate the verity on lookup().

As amir mentioned, this may not be optimal, and it may be beneficial
to sometimes delay the digest validation, but that is more of a
performance detail.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

