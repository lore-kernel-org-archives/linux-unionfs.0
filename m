Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C36E7D0AB
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 22:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjIUW1s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjIUW1e (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 18:27:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE6046AC
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hUA0LTyQq81FtAH8DG+wAjHXiFC/ZdyJJ4zc+Pob+4=;
        b=jUuuy9hoOCSpEUZGZQSgkTgTkF9b7zaeRsa3Z5Pt50Mqd9n+w/qCYwPHIhYOm+5Cfmn/Gs
        wHyHn9359Wy1v/sIrsg4QZ56vqnBcIwhUuwdXS/puwpaDaP7HRmJKnQ+0iCq3/hzgth5Lw
        gutyr0Y1Jo/1M+2TsZuj19+lxytQ8P0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-Si5GPCRFN6q6dGf5XQpkvA-1; Thu, 21 Sep 2023 13:06:31 -0400
X-MC-Unique: Si5GPCRFN6q6dGf5XQpkvA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c467c33c06so18595435ad.0
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Sep 2023 10:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695315990; x=1695920790;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hUA0LTyQq81FtAH8DG+wAjHXiFC/ZdyJJ4zc+Pob+4=;
        b=KuLJ7wT644xRzS8bvk2cmLGpkztzjzXTHeV92vjVXsr/E0pvRTHCFSkMgE+4W1sxRP
         wNieVSyMYUCu/NPbva39K21fhnTbztfCtNIPLbWF0oU/nzVE1Fuiie7g2zIKjrUJGluD
         GS2qJGBNC3XF621oPZ3MlAn2pC3jBJILIJ3wU+ioBOPepPhQ7B9emvxvD8H7HG8b9h5o
         xR1/lxn9Rl66SSIC80s61Bbl3/7PKxgUXEPCNfTOHTjKBNAS/EjfUkwpApuR5+yHUm1m
         9lSjmY9PUJ61K1lOB8F32P0zDlcbaqjEFGC79TaSna4jqVE8CmPL5bcEPqOMxqhX8KGe
         7gYw==
X-Gm-Message-State: AOJu0YzEnCEl7454w7hbxTLw0pgJ6HVFAGeC7zalLXqaDHal7sgYXM6z
        M7FYftoLJbvn51sFGaW0GzSvEn0XKzpVylCn9D+T/79rX5f7suZTTycTiqP0ZsPVSGyZd/mbdn5
        ov6AIJZDcxcksUf2duhZSA55pJw==
X-Received: by 2002:a17:902:f689:b0:1b4:5699:aac1 with SMTP id l9-20020a170902f68900b001b45699aac1mr307420plg.12.1695315990608;
        Thu, 21 Sep 2023 10:06:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEq20VS4UuwpQj2qY7mPiLR41qpIJcoM4f8zFr5QTY+NW4xy/tfn5q43C95H81ITPPVtfelVQ==
X-Received: by 2002:a17:902:f689:b0:1b4:5699:aac1 with SMTP id l9-20020a170902f68900b001b45699aac1mr307377plg.12.1695315990068;
        Thu, 21 Sep 2023 10:06:30 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b001c1ef9d2215sm1741980plx.270.2023.09.21.10.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 10:06:29 -0700 (PDT)
Date:   Fri, 22 Sep 2023 01:06:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/2] common: add helper _require_chattr_inherit
Message-ID: <20230921170626.hdqw5snvxtg4oxgl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230921143102.127526-1-amir73il@gmail.com>
 <20230921143102.127526-2-amir73il@gmail.com>
 <20230921152648.25wd4gqralgiuksv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj5YR4Kv2-EZXnQGDo1zbExKZ+mw=rYNVBpCo30KkFAfQ@mail.gmail.com>
 <20230921162319.gsh5is3vkptp5hz2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjgMjSY0fye1o-i-d44usfswuFebWBaQ6pE_od+HYGfrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjgMjSY0fye1o-i-d44usfswuFebWBaQ6pE_od+HYGfrQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 21, 2023 at 07:46:12PM +0300, Amir Goldstein wrote:
> On Thu, Sep 21, 2023 at 7:23 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Thu, Sep 21, 2023 at 06:40:49PM +0300, Amir Goldstein wrote:
> > > On Thu, Sep 21, 2023 at 6:26 PM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Thu, Sep 21, 2023 at 05:31:01PM +0300, Amir Goldstein wrote:
> > > > > Similar to _require_chattr, but also checks if an attribute is
> > > > > inheritted from parent dir to children.
> > > > >
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >  common/rc | 52 +++++++++++++++++++++++++++++++++++++++++++---------
> > > > >  1 file changed, 43 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/common/rc b/common/rc
> > > > > index 1618ded5..00cfd434 100644
> > > > > --- a/common/rc
> > > > > +++ b/common/rc
> > > > > @@ -4235,23 +4235,57 @@ _require_test_lsattr()
> > > > >               _notrun "lsattr not supported by test filesystem type: $FSTYP"
> > > > >  }
> > > > >
> > > > > +_check_chattr_inherit()
> > > > > +{
> > > > > +     local attribute=$1
> > > > > +     local path=$2
> > > > > +     local inherit=$3
> > > >
> > > > As I understand, this function calls _check_chattr_inherit, so it will
> > > > return zero or non-zero to clarify if $path support $attribute inheritance.
> > > > ...
> > > >
> > > > > +
> > > > > +     touch $path
> > > > > +     $CHATTR_PROG "+$attribute" $path > $tmp.chattr 2>&1
> > > > > +     local ret=$?
> > > > > +     if [ -n "$inherit" ]; then
> > > > > +             touch "$path/$inherit"
> > > > > +     fi
> > > >
> > > > ... but looks like it doesn't, it only create a $inherit file, then let the
> > > > caller check if the $attribute is inherited.
> > > >
> > > > I think that's a little confused.
> > >
> > > I agree.
> > >
> > > > I think we can name the function as _check_chattr()
> > >
> > > I agree.
> > >
> > > > and the 3rd argument $inherit as a bool variable, to
> > > > decide if we check inheritance or not.
> > > >
> > >
> > > Not my prefered choice.
> > >
> > > > Or you'd like to have two functions _check_chattr and _check_chattr_inherit,
> > > > _check_chattr_inherit calls _check_chattr then keep checking inheritance.
> > > >
> > > > What do you think?
> > >
> > > I think this is over engineering for a helper that may not
> > > be ever used by any other test.
> > >
> > > Suggest to just change the name to _check_chattr()
> > > to match the meaning to the return value.
> > >
> > > The 3rd inherit argument just means that we request
> > > to create a file after chattr + and before chattr -,
> > > so that the caller could check it itself later.
> >
> > I still think it doesn't make sense ... but I don't want to give you
> > that pressure, so ...
> >
> > >
> > > If you accept this minor change is enough
> > > can you apply it yourself on commit?
> >
> > ... If you think it's too complicated, we can drop the inheritance checking
> > common helper. Just change the _require_chattr(), make it to accept one more
> > *directory* argument (use $TEST_DIR by default). Then we can do:
> >
> > _require_chattr A $BASE_SCRATCH_MNT
> 
> This is not needed.
> Overlayfs (on $SCRATCH_MNT) will not pass the require_chattr
> check if the base fs does not support chattr.

Oh, I saw you wrote as this:

  +# prepare lower test dir with NOATIME flag
  +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
  +mkdir -p $lowerdir/testdir
  +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
  +       _notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag"

so I thought you might want a `_require_chattr A $BASE_SCRATCH_MNT`.

> 
> > _require_chattr A $SCRATCH_MNT
> 
> This is practically equivalent to _require_chattr A
> on the test partition, there is no reason to test the
> scratch partition specifically.
> 
> So there is no need for the proposed change in _require_chattr.
> 
> >
> > And then do all inheritance checking in the overlay case itself (likes you did in
> > V1), don't make them to be a common helper. Due to only this case need the
> > _require_chattr_inheritance, so we can think about that common helper when more
> > cases need that :)
> >
> > I think this change is simple enough (base on your V1 patch). Is that good to
> > you :)
> 
> V1 is good enough for me as is. :)
> You can take the commit message and test
> header comment fixes from V2.

I'll merge v2 patch 2/2, with ...
1) Change _require_chattr_inherit to _require_chattr.
2) Add `sleep 2s` under the "before=$(stat -c %x $lowerdir/testdir/lnk)" line.

Thanks,
Zorro

> 
> Note that the common _require_chattr_inheritance in V2
> almost did not remove any lines from the test at all -
> it moved one _notrun line into _require_chattr_inheritance
> and turned another _notrun into echo "fail".
> 
> So I agree that if no other test is going to use the new helpers
> their value is limited.
> 
> Thanks,
> Amir.
> 

