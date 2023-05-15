Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10389C7EE22
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 May 2023 06:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjEOGQJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 May 2023 02:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjEOGQI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2023 02:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE86A1FEF
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 23:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684131313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IrydVMF432xLQ5z//yarPaLUFV+WCQb/KK9Ty+7VJHU=;
        b=H9AlMMsJqXfOKGmD5OJJ0Huq1V7TVQvqJ35OMLiJHiIZmOqVyrRZhxIVfCpHNbl5BesvBv
        Uqpv1mknhWaCjlOqNb2n6qyNcGnThYSDhxIUnEZcrbgkPE4P5wkGHU+7iAGoSGoPpkDTta
        wmBZr7k/AhK09MyRwbYx6xdX4uCdeUs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-BCCQvOSdMGKOGWCpyxOhfQ-1; Mon, 15 May 2023 02:15:10 -0400
X-MC-Unique: BCCQvOSdMGKOGWCpyxOhfQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3314c25ae45so176378575ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 23:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684131310; x=1686723310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrydVMF432xLQ5z//yarPaLUFV+WCQb/KK9Ty+7VJHU=;
        b=Nq4MCQGpjlyWzlP9J2eQQhY1OmoYiUa7soXSmECHU3dGjR57KH5Y7Z7C/Ru5mRYKa+
         D78GbRoVpBI7+skJRzuStvk1F0hWaYDriwBCPhcOoxTnRLY8Zo32BUL02kk6naCRjVlY
         SnzHSGdMgHZ7CNDuKgivESnrxCgiV+Z8E/c2i0jc+WVxz8LSJ28Mu1uL2G9p8mtJX7Rs
         n8MZHm67lcB9D1dus8itsJq8llM8GJfiiceLBVoGWz0RqCVCtNyXZ/X0sGS1pSfXhvVq
         8lXldUPMpq9JFZVJvV2zCuPzIcjhGN8Vt+U0J12PLtqDA3RD5WpzzHJzbwGDq4E5WM0+
         vkng==
X-Gm-Message-State: AC+VfDw4kZKPDqvUETgoFXSH9igcG5g8a/XubyuucZBelrvEDSEDHe5X
        QcTqgnMXLz8SQ8++4KYHV2Eqi0XvygdG6Wo0ztgUCkiWsVKD8HmFGqjxGSuLb8+T/kRqRsmYUyi
        p4AgbHVmLgDq/1vfzC0Q6gi9cJyrmU+pdHxUlkXM6BA==
X-Received: by 2002:a92:dcc7:0:b0:325:eb13:1045 with SMTP id b7-20020a92dcc7000000b00325eb131045mr26522037ilr.2.1684131310106;
        Sun, 14 May 2023 23:15:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5bKLDDpSZDs7RFRlkTwbiDae1sl0GjNzBfGePZZHEzAXWikqfdZLHy5ZFJtGhcidHgYM+l0aa28k4m2ymI01I=
X-Received: by 2002:a92:dcc7:0:b0:325:eb13:1045 with SMTP id
 b7-20020a92dcc7000000b00325eb131045mr26522029ilr.2.1684131309927; Sun, 14 May
 2023 23:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain> <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 15 May 2023 08:14:59 +0200
Message-ID: <CAL7ro1Hqc29w-FuRuoEfcsxiXTnqqwHP73nwvmZRuKVRsz4D9w@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 11:00=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Sun, May 14, 2023 at 10:16=E2=80=AFPM Eric Biggers <ebiggers@kernel.or=
g> wrote:
> >
> > On Wed, May 03, 2023 at 10:51:38AM +0200, Alexander Larsson wrote:
> > > When resolving lowerdata (lazily or non-lazily) we check the
> > > overlay.verity xattr on the metadata inode, and if set verify that th=
e
> > > source lowerdata inode matches it (according to the verity options
> > > enabled).
> >
> > Keep in mind that the lifetime of an inode's fsverity digest is from wh=
en it is
> > first opened to when the inode is evicted from the inode cache.
> >
> > If the inode gets evicted from cache and re-instantiated, it could have=
 been
> > arbitrarily changed.
> >
> > Given that, does this verification happen in the right place?  I would =
have
> > expected it to happen whenever the file is opened, but it seems you do =
it when
> > the dentry is looked up instead.  Maybe that works too, but I'd appreci=
ate an
> > explanation.
>
> Hmm. I do not think it is wrong because the overlay file cannot be opened=
 before
> the inode overlay is looked up and fsverity is verified on lookup.
> In theory, overlay inode with lower could have been instantiated by decod=
e_fh(),
> but verity=3Don and nfs_export=3Don are conflicting options.
>
> However, I agree that doing verify check on lookup is a bit too early, as
> ls -lR will incur the overhead of verifying all file's data even
> though their data
> is not accessed in a non-lazy-lower-data scenario.
>
> The intuition of doing verity check before file is opened (or copied up)
> when there is a realfile open is not wrong, it would have gotten rid of t=
he
> dodgy ovl_ensure_verity_loaded(), but I think that will be a bit harder t=
o
> implement (not sure).
>
> My suggestion for Alexander:
> - Use ovl_set/test_flag(OVL_VERIFIED, inode) for lazy verify
> - Implement ovl_maybe_validate_verity() similar to
>   ovl_maybe_lookup_lowerdata()
> - Implement a helper ovl_verify_lowerdata()
>   that calls them both
> - Replace the ovl_maybe_lookup_lowerdata() calls with
>   ovl_verify_lowerdata() calls
>
> Then before opening (or copy up) a file, it could have either
> lazy lower data lookup or lazy lower data validate or both (or none).
>
> This will not avoid ovl_ensure_verity_loaded(), but it will load fsverity
> just before it is needed and it is a bit easier to take ovl_inode_lock
> unconditionally, in those call sites then deeper within copy_up, where
> ovl_inode_lock is already taken.
>
> I *think* this is a good idea, but we won't know until you try it,
> so please take my suggestion with a grain of salt.

I'll have a look at it in a bit. It would make performance of
verity=3Don in the non-lazy-lookup case better.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

