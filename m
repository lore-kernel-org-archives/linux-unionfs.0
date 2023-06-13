Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF7DEB64D0
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Jun 2023 13:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbjFMN6s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 09:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240426AbjFMN6q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Jun 2023 09:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DF010DC
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 06:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686664682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UEJ8D9gbYcwWPQg40ZDw3VfrRidvBZYa0oUX+g7tSYE=;
        b=GucNqLB6oY2ygiJ4S1XqrdQdXrGqFvg9C13VyaSOZEEnFbObH5OxxQ9Dq9UJz5oIYRB4ve
        nWo+i66OR721P3Sq4YEKAXleNsgCvyZvOA63FkIsZ6Jx8ycVFR1hP2tCuEoPVyiIj7pAKQ
        up3u3CFqlbaLL9QL5tRDFuIpfCKdNFs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-BdCzGIT3O4S3gqSpf9oo7w-1; Tue, 13 Jun 2023 09:58:00 -0400
X-MC-Unique: BdCzGIT3O4S3gqSpf9oo7w-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-340762ac229so3999575ab.0
        for <linux-unionfs@vger.kernel.org>; Tue, 13 Jun 2023 06:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686664680; x=1689256680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UEJ8D9gbYcwWPQg40ZDw3VfrRidvBZYa0oUX+g7tSYE=;
        b=iZrXHKXXnNd/fewsUJgE1jq7RO2+z5O0N/54sxBw/rtDvN95jxtZv1k/TKCrqLkS6O
         8iSdJyNvu46gQ9zbEHGmTJebYBbmLsIWyscEG0soy5b+t8fTHVGFdRQN4YZVVtE8AvKl
         St66rT0gr9wwLXg+NicmKawLUqHJPh6hro/ztDKSK3DSb8QghWThwi/ZdE1ma7qQ5jR2
         YkF5+DXBn6jEycJf11eaAYGLbkCUMEilKn13ry3T/xhXjWE0ikbp6A6hh58X5grLcTAF
         KFHTnQ/wFmrZYcMJS22BFihnu9zUa9SodYxUkQfdtBowOzKO+HU2kxvOKn4x4i2MZk9O
         AzUg==
X-Gm-Message-State: AC+VfDz4OBMlb7iCQNsuMSGJYjClhTxTGa6y9jxXI8RWuoQfPNxA+4M+
        N/IMay3dnIYH1ewdS7/389g+Zo0AIEt1CmIDudJXZyxNxcGI/vgc+6zfK2pZpN0mPjRu50U+xcU
        CSQZqOBhgRvynu5SVi1f2mZ42gzNh+B6X/k1sApNTTw==
X-Received: by 2002:a92:c686:0:b0:334:de38:d600 with SMTP id o6-20020a92c686000000b00334de38d600mr9335757ilg.3.1686664679841;
        Tue, 13 Jun 2023 06:57:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6bVatOmIWP1/VH2aADCiQGu+mBCtCJT8G2qu0r5Kk4teagU5wnCK7nNljakyvJ21X4ixpwPBYlZDS7B+HmYbg=
X-Received: by 2002:a92:c686:0:b0:334:de38:d600 with SMTP id
 o6-20020a92c686000000b00334de38d600mr9335744ilg.3.1686664679516; Tue, 13 Jun
 2023 06:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com>
In-Reply-To: <cover.1686565330.git.alexl@redhat.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 13 Jun 2023 15:57:48 +0200
Message-ID: <CAL7ro1EWzvWvwsO4dTc28HVj9nGfniz8HFix=pm40giTGv3YAg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 12, 2023 at 12:27=E2=80=AFPM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> This patchset adds support for using fs-verity to validate lowerdata
> files by specifying an overlay.verity xattr on the metacopy
> files.
>
> This is primarily motivated by the Composefs usecase, where there will
> be a read-only EROFS layer that contains redirect into a base data
> layer which has fs-verity enabled on all files. However, it is also
> useful in general if you want to ensure that the lowerdata files
> matches the expected content over time.
>
> I have also added some tests for this feature to xfstests[1].
>
> I'm also CC:ing the fsverity list and maintainers because there is one
> (tiny) fsverity change, and there may be interest in this usecase.
>
> Changes since v2:
>  * Rebased on top of overlayfs-next
>  * We now alway do verity verification the first time the file content
>    is used, rather than doing it at lookup time for the non-lazy lookup
>    case.
>
> Changes since v1:
>  * Rebased on v2 lazy lowerdata series
>  * Dropped the "validate" mount option variant. We now only support
>    "off", "on" and "require", where "off" is the default.
>  * We now store the digest algorithm used in the overlay.verity xattr.
>  * Dropped ability to configure default verity options, as this could
>    cause problems moving layers between machines.
>  * We now properly resolve dependent mount options by automatically
>    enabling metacopy and redirect_dir if verity is on, or failing
>    if the specified options conflict.
>  * Streamlined and fixed the handling of creds in ovl_ensure_verity_loade=
d().
>  * Renamed new helpers from ovl_entry_path_ to ovl_e_path_
>
> [1] https://github.com/alexlarsson/xfstests/commits/verity-tests

I pushed a new version of this branch with the following changes:

 * Includes and uses the new fsverity_get_digest() rework from Eric
 * The above means we now use the FS_VERITY_ALG_* enum values in the xattr
 * Made the overlayfs.rst document change a bit more explicit on what
happens and by whom
 * Ignore EOPNOTSUPP failure from removexattrs as pointed out by Amir

The previous patchset is available as the overlay-verity-v3 tag so you
can compare the differences.

