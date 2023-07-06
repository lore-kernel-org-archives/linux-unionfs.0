Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD3AEB64DC
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 10:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjGFK0z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 06:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjGFK0x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 06:26:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490DA170C
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 03:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688639168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nr8c87Dw166iiK+BeyHam2+kseL0u8KTw29HsYgZ7TE=;
        b=RTXNs7C/jaCdEqDmpJXz04Iezmxro9tq5C6PffuCGeb58Fbcudv7pmogM0YbdIczibu6Xl
        TXAjIY6Qis4Sgua730QmCI8Aa+cJJ9f/bG5odiw6MscZskeUmOigbIrHbF4zw28fimE6ZT
        BgkdgigrAE6zZVFV/dEnSjr2T5flCyE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-Li180bIqPmK8qgvuCM0OLg-1; Thu, 06 Jul 2023 06:26:06 -0400
X-MC-Unique: Li180bIqPmK8qgvuCM0OLg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-784fd6bfbcdso19071839f.1
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Jul 2023 03:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688639166; x=1691231166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nr8c87Dw166iiK+BeyHam2+kseL0u8KTw29HsYgZ7TE=;
        b=kRtaCOpNyJfknLisIBNoXluLqEKeel2palZ2Yvj6+wBqNeGSTxSxOxo4GL+vdfBVj2
         J9bNk3DU4qlC1xOf0td8VdcOd4JanOx/NvgJH8N/uOX/MoOlZAzEDDvHrGwHUXNuO+ob
         WvvlneOqnzaa8uOMXexmOnaaGmQW2gBbRqYnt21XtWTyzgVwn8Kl4h8bign+UbZdmspw
         PuO4ltTpWHVgzwnvuxcwAIydPjRwMdevg/4l1T30+Xcbq++TVwz2j6MhXL4n1/rov5By
         AvKnF0BUUogEiz3jWSytsX9Yu8Ly5sD4382ixTDw+uCO9wUJ3+BizqC6YzNPbRR+pcIX
         BX1A==
X-Gm-Message-State: ABy/qLb2Sb8YndMVnJavG7iU2Qdrxmtx02zXM2hcF+Hn4ORagZ1jUC/7
        F1ZC/2zE0allix4kv1f88RlqSpAALUJQx1oGiFzApGwHaimadOkdYJCF+XuNdKERE10FE69dDDI
        syAGkcx98l9ONlEl2k0eDBe4bZKufK4kUXVtZx+qXig==
X-Received: by 2002:a92:c142:0:b0:345:775f:1a2f with SMTP id b2-20020a92c142000000b00345775f1a2fmr1722976ilh.14.1688639166016;
        Thu, 06 Jul 2023 03:26:06 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHTftu8A4Sjy3SmrcRvaP5pzqVXOV1/fySiKXtTlE0d+AuTSi4k8DXVkciZVx8wHIaFeFDbITLNk5AWqlMgqwk=
X-Received: by 2002:a92:c142:0:b0:345:775f:1a2f with SMTP id
 b2-20020a92c142000000b00345775f1a2fmr1722964ilh.14.1688639165702; Thu, 06 Jul
 2023 03:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1688634271.git.alexl@redhat.com> <669007608d711c1c4f6b8f835affc2660084f76c.1688634271.git.alexl@redhat.com>
In-Reply-To: <669007608d711c1c4f6b8f835affc2660084f76c.1688634271.git.alexl@redhat.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 6 Jul 2023 12:25:54 +0200
Message-ID: <CAL7ro1EORfKBHH7bad8ixKvDX3nhvL9FSMHy8uHp0HQ8DUPC7g@mail.gmail.com>
Subject: Re: [PATCH 2/4] overlay/060: add test cases of follow to lowerdata
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 6, 2023 at 11:50=E2=80=AFAM <alexl@redhat.com> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> Add test coverage for following metacopy from lower layer to
> lower data with absolute, relative and no redirect.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Signed-off-by: Alexander Larsson <alexl@redhat.com>

> ---
>  tests/overlay/060     | 43 ++++++++++++++++++++++++++++++++++++++-----
>  tests/overlay/060.out | 18 ++++++++++++++++++
>  2 files changed, 56 insertions(+), 5 deletions(-)
>
> diff --git a/tests/overlay/060 b/tests/overlay/060
> index 363207ba..f37755da 100755
> --- a/tests/overlay/060
> +++ b/tests/overlay/060
> @@ -7,7 +7,7 @@
>  # Test metadata only copy up functionality.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick metacopy prealloc
> +_begin_fstest auto quick metacopy redirect prealloc
>
>  # Import common functions.
>  . ./common/filter
> @@ -123,6 +123,13 @@ mount_overlay()
>         _overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o re=
direct_dir=3Don,index=3Don,metacopy=3Don
>  }
>
> +mount_ro_overlay()
> +{
> +       local _lowerdir=3D$1
> +
> +       _overlay_scratch_mount_dirs "$_lowerdir" "-" "-" -o ro,redirect_d=
ir=3Dfollow,metacopy=3Don
> +}
> +
>  umount_overlay()
>  {
>         $UMOUNT_PROG $SCRATCH_MNT
> @@ -146,7 +153,8 @@ test_common()
>         check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
>         check_file_blocks $SCRATCH_MNT/$_target $_blocks
>
> -       # Make sure copied up file is a metacopy file.
> +       # Trigger metadata copy up and check existence of metacopy xattr.
> +       chmod 400 $SCRATCH_MNT/$_target
>         umount_overlay
>         check_metacopy $upperdir/$_target "y"
>         check_file_size_contents $upperdir/$_target $_size ""
> @@ -165,7 +173,7 @@ test_common()
>  create_basic_files()
>  {
>         _scratch_mkfs
> -       mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
> +       mkdir -p $lowerdir/subdir $lowerdir2 $upperdir $workdir $workdir2
>         mkdir -p $upperdir/$udirname
>         echo "$lowerdata" > $lowerdir/$lowername
>         chmod 600 $lowerdir/$lowername
> @@ -184,12 +192,19 @@ create_lower_link()
>
>  prepare_midlayer()
>  {
> +       local _redirect=3D$1
> +
>         _scratch_mkfs
>         create_basic_files
> +       [ -n "$_redirect" ] && mv "$lowerdir/$lowername" "$lowerdir/$_red=
irect"
>         # Create midlayer
>         _overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o red=
irect_dir=3Don,index=3Don,metacopy=3Don
> -       # Trigger a metacopy
> -       chmod 400 $SCRATCH_MNT/$lowername
> +       # Trigger a metacopy with or without redirect
> +       if [ -n "$_redirect" ]; then
> +               mv "$SCRATCH_MNT/$_redirect" "$SCRATCH_MNT/$lowername"
> +       else
> +               chmod 400 $SCRATCH_MNT/$lowername
> +       fi
>         umount_overlay
>  }
>
> @@ -254,6 +269,24 @@ mount_overlay $lowerdir
>  mv $SCRATCH_MNT/$lowerlink $SCRATCH_MNT/$ufile
>  test_common $lowerdir $ufile $lowersize $lowerblocks "$lowerdata" "/$low=
erlink"
>
> +echo -e "\n=3D=3D Check follow to lowerdata without redirect =3D=3D"
> +prepare_midlayer
> +mount_ro_overlay "$lowerdir2:$lowerdir"
> +test_common "$lowerdir2:$lowerdir" $lowername $lowersize $lowerblocks \
> +               "$lowerdata"
> +
> +echo -e "\n=3D=3D Check follow to lowerdata with relative redirect =3D=
=3D"
> +prepare_midlayer "$lowername.renamed"
> +mount_ro_overlay "$lowerdir2:$lowerdir"
> +test_common "$lowerdir2:$lowerdir" "$lowername" $lowersize $lowerblocks =
\
> +               "$lowerdata"
> +
> +echo -e "\n=3D=3D Check follow to lowerdata with absolute redirect =3D=
=3D"
> +prepare_midlayer "/subdir/$lowername"
> +mount_ro_overlay "$lowerdir2:$lowerdir"
> +test_common "$lowerdir2:$lowerdir" "$lowername" $lowersize $lowerblocks =
\
> +               "$lowerdata"
> +
>  # success, all done
>  status=3D0
>  exit
> diff --git a/tests/overlay/060.out b/tests/overlay/060.out
> index a4790d31..f4ce0244 100644
> --- a/tests/overlay/060.out
> +++ b/tests/overlay/060.out
> @@ -40,3 +40,21 @@ check properties of metadata copied up file
>  Unmount and Mount again
>  check properties of metadata copied up file
>  check properties of data copied up file
> +
> +=3D=3D Check follow to lowerdata without redirect =3D=3D
> +check properties of metadata copied up file
> +Unmount and Mount again
> +check properties of metadata copied up file
> +check properties of data copied up file
> +
> +=3D=3D Check follow to lowerdata with relative redirect =3D=3D
> +check properties of metadata copied up file
> +Unmount and Mount again
> +check properties of metadata copied up file
> +check properties of data copied up file
> +
> +=3D=3D Check follow to lowerdata with absolute redirect =3D=3D
> +check properties of metadata copied up file
> +Unmount and Mount again
> +check properties of metadata copied up file
> +check properties of data copied up file
> --
> 2.40.1
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

