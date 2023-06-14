Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21D0EB64DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jun 2023 07:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbjFNHQd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbjFNHQB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2023 03:16:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB68E1BD3
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686726914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJIs/hs3NIZh37+QvWYEbF0szH9F4CbUfRoYwtu+xK0=;
        b=bHu4HmHsmgDprq2bICqMCRvdZUBAsIHf99zX5pt1DX1YOzFo7cTbXOv1NN1SyrpYmBR8ml
        tlWL7x3/jQVcBz2rtXlU/1m6A42OPnrlhqtqOQhpF4IHG0x7r8QZnfJBx5Z6MH6HOSQiCe
        IFa0v0ViiQlDmbrVXHozr067iyjBNzQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-bf6ciY3FPDKNOcksQT7sqA-1; Wed, 14 Jun 2023 03:15:12 -0400
X-MC-Unique: bf6ciY3FPDKNOcksQT7sqA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3406eef1dbeso11999565ab.2
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2023 00:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686726912; x=1689318912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJIs/hs3NIZh37+QvWYEbF0szH9F4CbUfRoYwtu+xK0=;
        b=SeXHOswHZwzP52GYYkKM+6bQAzrFLsk+29whLosh5/QW9BmnWRCvv2530Qz1gVhQgD
         60mCfr4j3JVXO90TeAg52VnlwPeGGiN49CHNK5mqljg4PTKyD/HNC1IOahf6pmbS0y9L
         KIiAJox3b3djLg6eZ9JldxUiIrqEh8Ui4c4zW2YXtiT/pRYeJGV9ocaAnJsoMVYAKYwv
         vRSSe82FyyuW8NAtUsZP0FWGbb7E+9McljvxiYv514XJxHquuoNnh4xN40e5AH9ZBkZZ
         ZttXHrGs2rFpbbS2TcOWYMmJZ1LP1nOpSP8KDah57vmnO/MGpLe1ZT0IG6sDgxFaKgOB
         Cdrg==
X-Gm-Message-State: AC+VfDwHnjR3uqTxuxmrNdgx8L3ybENLGNleCzmiWpRYg3n5+sxCPK5I
        osoyw7A1z4fY08R2bo5a12li4iNn3nVv4j6wqoG5OQa6HdwklJvN6WOwf8aa7OgIbRBx74W1zGV
        v320qoHbRvOFuInZey3z1AvvGj4ztI91TwGcPNpQ8Nf2TuOFtts8n
X-Received: by 2002:a92:4a10:0:b0:33d:2912:b15c with SMTP id m16-20020a924a10000000b0033d2912b15cmr12513610ilf.11.1686726911873;
        Wed, 14 Jun 2023 00:15:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7wT/JsQCu/LDqZFslfJmgnN77R7c4Oxdd1jRDKxKg8z8AMMmc4GHhl+3KY4XmGLNN6EXPpLLun6KjsFjsqBOA=
X-Received: by 2002:a92:4a10:0:b0:33d:2912:b15c with SMTP id
 m16-20020a924a10000000b0033d2912b15cmr12513603ilf.11.1686726911658; Wed, 14
 Jun 2023 00:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAL7ro1EWzvWvwsO4dTc28HVj9nGfniz8HFix=pm40giTGv3YAg@mail.gmail.com>
 <20230613175927.GB1139@sol.localdomain>
In-Reply-To: <20230613175927.GB1139@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 14 Jun 2023 09:15:00 +0200
Message-ID: <CAL7ro1E4rcW967yC6qiYcUKicEuWe739GgC-J2_4LOLZqgghMQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 13, 2023 at 7:59=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 13, 2023 at 03:57:48PM +0200, Alexander Larsson wrote:
> >
> > I pushed a new version of this branch with the following changes:
> >
> >  * Includes and uses the new fsverity_get_digest() rework from Eric
> >  * The above means we now use the FS_VERITY_ALG_* enum values in the xa=
ttr
> >  * Made the overlayfs.rst document change a bit more explicit on what
> > happens and by whom
> >  * Ignore EOPNOTSUPP failure from removexattrs as pointed out by Amir
> >
> > The previous patchset is available as the overlay-verity-v3 tag so you
> > can compare the differences.
> >
>
> Where can I find the new version?

Sorry, its at https://github.com/alexlarsson/linux/commits/overlay-verity

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

