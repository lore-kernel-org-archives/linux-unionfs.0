Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756A4EE57FA
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Sep 2023 11:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbjIHLTs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 07:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbjIHLTr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2023 07:19:47 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FDF11B
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Sep 2023 04:19:43 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-450711d9bf1so806717137.1
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2023 04:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694171982; x=1694776782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYkIbrXOmMwxaowEvFfNHJ267X7UrmN17LvN01V8qqc=;
        b=VVtsAqUjDy77RmTnqXXzkYDFNNEoApaVm2rJa9lWr7Oa7bdEvAndXUOL0941fPi8w9
         grdTSl6Q9PrSJNFfd4G4o8NpX3v5bd6bizuvCCASqriTWy5z4BFkgDtNjrScezqPi+G5
         Jn1rOEajUfho2ZZ06YwqL7d3uCbgrAkQXfl6AfhCRCdhriQf4xiEZDSHBZmqvIX9PiGT
         RNhb9Za4YrMaFLjvvIsnPW+o4dhTQxTEPFX4Vj/lV75pksjn+GbESS4sbNoe4ISvXsix
         +9pYUcOY+L4v6t2v64NoVXesjjp/NVAmX/gD1foQpC2pCGb+lmrGKvFa/H1C3BFCmBC3
         pBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694171982; x=1694776782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYkIbrXOmMwxaowEvFfNHJ267X7UrmN17LvN01V8qqc=;
        b=QJZy4pcln+A4zWHb6uHlSyAiRzRsKKyzpyYpb799t9FBadDVb6JCVyC3WF6zcAGy8O
         CV6Jl2EG/uW7f31VJhuvUtvhl2Hi2yczR+1+o5Wf+M2DPMzHyAc3seCmVVIdEBoKrXOR
         E4YXFZExJABG94FS39smCt3+t5Wv2yh2nfF5UqT9KthZj2uXrvl9pbaxvuJecnVd13dl
         mTAzVHNSVHxR9aM2g68BDB+5nJK//IpANWi7UgdoJBW2wIevfRPLlbthNTypvBWMGc7t
         wmSbAc7xUC2RR1tyGU6IN8N7RXDXCTpj/oUSFLKWbCCp3e+9FR66BIPU+i6aZ5BZBYPs
         FwHQ==
X-Gm-Message-State: AOJu0YwVwm8ZRE4LYTAA03x9hPqiRhRIKzoAfQP3cg/adWr7OxXK3gsK
        Yuf0xYbuuvP/6CH0s1pMR+itLFjuCPYbRzZq/OJOgg7ng8w=
X-Google-Smtp-Source: AGHT+IFiefUsiyjw4cabZlohnwnZg+fdx4Cvnft612PqzG4FybXGIXV+SBUoLPaRQM3JdpjzN/fhgdOpC5Yt6U1OhUo=
X-Received: by 2002:a05:6102:2846:b0:44e:9afe:c5b2 with SMTP id
 az6-20020a056102284600b0044e9afec5b2mr2323629vsb.27.1694171982244; Fri, 08
 Sep 2023 04:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <acb6243943171a353091fa92cf1ffbf92bcb26ba.1694075674.git.alexl@redhat.com>
 <CAOQ4uxjn8dF6K03jmyy64HURV2GXsY0DDBNOqfKNpk5k9E0AEg@mail.gmail.com> <CAL7ro1F2vxqp5gwvRzavZ6QRVw57+RHxv=iHJk-Z9X3_ibg21w@mail.gmail.com>
In-Reply-To: <CAL7ro1F2vxqp5gwvRzavZ6QRVw57+RHxv=iHJk-Z9X3_ibg21w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 8 Sep 2023 14:19:31 +0300
Message-ID: <CAOQ4uxi=VHE22+LPG0jyBwk5L38vmK65Bb4NjhfRUz1vf4tNTw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] ovl: Handle escaped xwhiteouts across layers
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 8, 2023 at 11:15=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
>
>
> On Thu, Sep 7, 2023 at 2:28=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>>
>> On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:
>> >
>> > We use the "overlay.whiteouts" to mark any directory in a lower dir th=
at may
>> > contain "overlay.whiteout" files (xwhiteouts). This works even if othe=
r layers
>> > overlap that directory in a mount.
>> >
>> > For example, take these files in three layers:
>> >
>> >  layer2/dir/ - overlay.whiteouts
>> >  layer2/dir/file - overlay.whiteout
>> >  layer1/dir/
>> >  layer1/dir/file
>> >
>> > An overlayfs mount with -o lowerdir=3Dlayer2:layer1 would have a white=
out in
>> > layer2.
>> >
>> > However, suppose you wanted to put this inside an overlayfs layer (say
>> > "layerA"). I.e. you want to escape the whiteouts above so that when th=
e new
>> > layer is mounted using overlayfs the mount shows the above content. Th=
e natural
>> > approach is to just take each layer and escape it:
>> >
>> >  layerA/layer2/dir/ - overlay.overlay.whiteouts
>> >  layerA/layer2/dir/file - overlay.overlay.whiteout
>> >  layerA/layer1/dir/
>> >  layerA/layer1/dir/file
>> >
>> > This initially seems to work, however if there is another lowerdir (sa=
y
>> > "layerB") that overlaps the xwhiteouts dir, then this runs into proble=
m:
>> >
>> >  layerB/layer2/dir/ - **NO overlay.overlay.whiteouts **
>> >  layerA/layer2/dir/ - overlay.overlay.whiteouts
>> >  layerA/layer2/dir/file - overlay.overlay.whiteout
>> >  layerA/layer1/dir/
>> >  layerA/layer1/dir/file
>> >
>> > If you mount this with -o lowerdir=3DlayerB:layerA, then in the final =
mount,
>> > there will be no overlay.whiteouts xattrs on the "layer2/dir" merged
>> > directory, because the topmost lower dir xattrs win.
>> >
>> > We would like this to work as is, to avoid having layer escaping depen=
d on other
>> > layers. So, to fix this up we special case the reading of escaped
>> > "overlay.whiteouts" xattrs by looking in all layers for the first hit.
>> >
>>
>> I have a few issues with this special casing:
>> 1. Miklos did not speak his opinion yet
>>
>> 2. I don't like special casing by suffix nor special casing a single xat=
tr
>
>
> For the suffix part, that is because we need to do the same for multiple =
escaped xattrs.
>
> Like, if you have "overlay.overlay.overlay.whiteouts", which gets unescap=
ed to "overlay.overlay.whiteouts" in a mount, you run into the same behavio=
ur:
>
>   layerB/layer2/dir/file3
>   layerB/layer2/dir/ - **NO overlay.overlay.overlay.whiteout **
>   layerA/layer2/dir/ - overlay.overlay.overlay.whiteout
>   layerA/layer2/dir/file2
>   layerA/layer1/dir/
>   layerA/layer1/dir/file1
>
> If you were to mount B:A over the 2:1 mount, and you getxattr(overlay.ove=
rlay.whiteout) on mnt/dir you would get ENODATA, unless you also special-ca=
sed the multiple escaped xattrs. So if you wanted to use this mount to nest=
 yet another level it would not work.
>
> But, that does speak to the general question that maybe even more xattrs =
need this kind of treatment.
>
>> 3. I can think of example like this:
>>
>>   layerB/layer2/dir/file3
>>   layerB/layer2/dir/ - **NO overlay.overlay.opaque **
>>   layerA/layer2/dir/ - overlay.overlay.opaque
>>   layerA/layer2/dir/file2
>>   layerA/layer1/dir/
>>   layerA/layer1/dir/file1
>>
>> LayerB doesn't have layer1 so it does not know that
>> opaque is needed, therefore opaque needs to be merged
>> as well in this case.
>
>
> I think you may be right here.
>
> My original thought was when using the traditional mechanism for creating=
 lower dirs, i.e. by make overlayfs create an upper and then reuse it as lo=
wer, we would not run into this situation. Because when overlayfs copy-ups =
"layer2/dir" to layerB it would copy the xattrs from the lower dir, so you =
wouldn't end up with NO overlay.overlay.opaque.
>
> However, copy_up.c treats the escaped xattrs as ovl_is_private_xattr, so =
they don't get copied up, even in this setup.
>
>>
>> Can we employ the logic of ovl_xattr_get_first() for any
>> escaped xattr prefix on a merge dir?
>
>
> We could either make escaped xattrs be copied up,

Seems to me that they should be copied up.
A copy up should not hide xattrs that are visible before copy up.

> or we could use ovl_xattr_get_first() for all escaped xattrs.
> I'm not sure the latter is right though. What if you *wanted* to drop the=
 opaque mark in the new image version (ie. layerB). If we always used ovl_x=
attr_get_first() then it would not be possible.
>

I must admit that I personally cannot follow all the user cases that we wan=
t
to cover and I think that the opaque example above demonstrates that there
is no one answer that fits all use cases.

> Maybe it's just a fact of life that escaping xattrs like this means you j=
ust *have* to care about lower layers when escaping a layer, and we should =
stop trying to make it not so. However, if we do that, then we should make =
ovl_copy_xattr() copy up escaped xattrs.
>

Not sure what you are suggesting.
If you are suggesting to drop this patch and fix the
xattr escaping patch to copy up escaped xattr
then I completely agree.

Thanks,
Amir.
