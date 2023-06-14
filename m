Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FB2EB64D9
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjFNHXN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbjFNHWP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2023 03:22:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC52295D
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686727187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pCHUjyR9Iz29Lv6cKyWgShfYL2WKapdtIdczZk9ZcU=;
        b=D6GWRnVUrenCW+L94vkeqU67X1QE4s2BuSUdqcpd+4SyazAJf9nPzkhNp0OpgN1dotvuAt
        WBlc1PSQiuFfTzubcwruxVhaLx5hdP1R6xNPlamkgxvjzI3W2VP19doXpTdSZRKm5/uZi/
        st6EZMEyiWK8VXwzaOTL7562aPn0jFw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-DdQgbg7aOZ6dkPkiaqZ-UQ-1; Wed, 14 Jun 2023 03:19:46 -0400
X-MC-Unique: DdQgbg7aOZ6dkPkiaqZ-UQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34083c0f42cso8527525ab.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727185; x=1689319185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pCHUjyR9Iz29Lv6cKyWgShfYL2WKapdtIdczZk9ZcU=;
        b=ftK0u2COZXOA9T4MXOmp7bk9QXzwL9oQEOORXqayS7wslVx63O4RdItCuQtnoC+6BA
         QViwjKQhIkZcaBQ/9gFZcJnPcCb0xiVcyVWkuj2MjeyqTfAPr1+7CHZtyO50fwJHmVT+
         KszSVlOtiLWZoGQh7qDx9eRW7I02rUi+VLf0oAn61uLqECYwzSPHgyci14ARfKFSomr7
         h90VKfkkV0jvhq2oSGDeGYCH+U/S79+u4CsZHRhx4haDMt9BMOE2gGSR45gP/Sd4S6xl
         BfEtUa4yHspfFa2GK2JlcmBJVDQYm8Ln/2YDXdJSzlMXld7tspIeu6WMoIyZh5qM5kdV
         E1Wg==
X-Gm-Message-State: AC+VfDwmNJTeAw4R24kWQiub41xlinyPXLeTIjJo+TR6/eWcaxdU+bnr
        17fO05oC75g7gSDR6m/V4+YzSw+Fr+V7JMux4wkuh1Fm0Ti+VYHW8gDVjIjtCByeiQTXqu4k1xD
        vkjaMzKjMeMINkrdO59Mz6mT9IB2rSpustF9WZpy7d5jS9LYL0g==
X-Received: by 2002:a05:6e02:60b:b0:33e:325a:cc0d with SMTP id t11-20020a056e02060b00b0033e325acc0dmr820462ils.2.1686727185453;
        Wed, 14 Jun 2023 00:19:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6NvcK9EjuJTD90FDBzgLJXunqZKTfxqE9fL1zhDpVNZQcYTV1jLq4gBp10xsVhSHP4LjUt1ILT5e2UFwZC3wY=
X-Received: by 2002:a05:6e02:60b:b0:33e:325a:cc0d with SMTP id
 t11-20020a056e02060b00b0033e325acc0dmr820453ils.2.1686727185262; Wed, 14 Jun
 2023 00:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <dd294a44e8f401e6b5140029d8355f88748cd8fd.1686565330.git.alexl@redhat.com>
 <20230612190944.GB847@sol.localdomain> <CAL7ro1Feep_aQimxEJzKk+4cv6-UNgco3VNDKZrrC3y2u04DCw@mail.gmail.com>
 <20230613175759.GA1139@sol.localdomain> <20230614032813.GA1146@sol.localdomain>
In-Reply-To: <20230614032813.GA1146@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 14 Jun 2023 09:19:34 +0200
Message-ID: <CAL7ro1EA6kzojYuwXAkLvQNNGQ=bx2UmQmg_jaCD3omEPekAbA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: Validate verity xattr when resolving lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 14, 2023 at 5:28=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 13, 2023 at 10:57:59AM -0700, Eric Biggers wrote:
> > On Tue, Jun 13, 2023 at 01:41:34PM +0200, Alexander Larsson wrote:
> > > > Can you consider
> > > > https://lore.kernel.org/r/20230612190047.59755-1-ebiggers@kernel.or=
g which would
> > > > make fsverity_get_digest() support both types of IDs?  Then you can=
 use
> > > > FS_VERITY_HASH_ALG_*, which I think would make things slightly easi=
er for you.
> > >
> > > Sounds very good to me. I'll rebase the patchset on top of it. Not
> > > sure how to best land this though, are you ok with this landing via
> > > overlayfs-next?
> >
> > If you're confident that this series will land in v6.4, then sure, you =
can apply
> > my patch "fsverity: rework fsverity_get_digest() again" to overlayfs-ne=
xt,
> > instead of me taking it through fsverity/for-next.  (Hopefully the IMA
> > maintainer will ack it as well, as it touches security/integrity/.)
> >
> > Just be careful about being overly-optimistic about features landing in=
 the next
> > release.  I've had experience with cases like this before, where I didn=
't apply
> > something for a reason like this, but then the series didn't make it in=
 right
> > away so it was worse than me just taking the patch in the first place.
> >
> > I do see that the other prerequisites were just applied to overlayfs-ne=
xt, so
> > maybe this is good to go now.  It's up to the other overlayfs folks.
>
> I meant to say 6.5, not 6.4.
>
> Anyway, just let me know if I should apply it or not, before it gets too =
late.

Honestly, I have no idea about the timescale here. That is all up to
miklos really. Maybe best to do as amir say and take it through your
tree but on from a branch that milklos can merge into overlafs-next if
he wants to take it this cycle.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

