Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AABCD6E5C
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346731AbjJKKTS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbjJKKTH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 06:19:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCD710C8
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 03:18:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9b96c3b4be4so1121069466b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 03:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697019524; x=1697624324; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1V7FBIDehDwALgmASabrkHyfOh+E30qL1DKB1VyXCRs=;
        b=ckiVjlNjduv3JrfQMz/RvmUwKwH479XoT2tQG2Bh/EgDAAbZwi/2RH4eWZsOQOOcGU
         tddirlygSLWwBJ8ru9G484Kqz75kWLVYCyyVH2bNmdE6izJmmpkJrax7jktV7VnBbxSH
         3UDi/aULkLwr/tdj7BKkYR7EBTWlr7D/5kWvw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697019524; x=1697624324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1V7FBIDehDwALgmASabrkHyfOh+E30qL1DKB1VyXCRs=;
        b=X16SZ1VjDu+mJH+YUU5WpOld+kqoEoSCqeYOesPiflkYCoyyNEFumP3ZTGfHPmwU5v
         udZnG1SHbLepfePTcuKgdxe0UqGH9LRYeJ64EKsI0QSQnDr6JFKcgVS8jKAD0WiNTQnj
         Rzne9Rz/nmJ1NYZptDclkUcix5d0/x+kn3ULwWgiJ/oxgwGk88U6SeGrzUaPlDTw7XuS
         jBj19ezm+3cRanAto5w11+Nz4JTS76GMhdHdReRbjZBuy1jbcRd3Cz4MrrXxyI8jgvaz
         m5hvqhakkHaUTYwyLPLn3ak/SokoyoehcBjntm2z/8ZkRSXOIk2cuhdb6mi7Pbzxd5S0
         lb4A==
X-Gm-Message-State: AOJu0YwLColT0lEKoWxiDPR7mG/ta7OMJLxbuOa/C4u8iG1poIwWqiOl
        dVscIBPAXjFTv1Y48ByD7LcTxSpQ8wzxlJDawqIMHA==
X-Google-Smtp-Source: AGHT+IEnrnXSTuVCieTSeAWSEg2B4ySoyi7AUHbCvis2grhZQzokQ8s0Ye7nCoF3NFbmyi6QJRM6iFfqxMhmixZRZXg=
X-Received: by 2002:a17:906:20c7:b0:9ae:5db5:13d with SMTP id
 c7-20020a17090620c700b009ae5db5013dmr18656714ejc.72.1697019523955; Wed, 11
 Oct 2023 03:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com> <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 11 Oct 2023 12:18:32 +0200
Message-ID: <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 11 Oct 2023 at 10:45, Amir Goldstein <amir73il@gmail.com> wrote:

>
> We could add new keys:
> lowerdir_first=,lowerdir_next=,lowerdatadir_next=
> as explicit variants for the "[^:]",":","::" prefix detection
> and those don't need to be unescaped.

Good idea.  I'd merge "lowerdir_first" and "lowerdir_next" into
"lowerdir_one" or whatever for simplicity.  I'd also consider dropping
the prefix detection, since it has only been in mainline for one
cycle.

> > >
> > > Anyway, let's focus on what you would like best.
> > > If you prefer to just fix the regression, it is doable.
> > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
> > > find a volunteer to write it up.
> >
> > It's not all good: when showing these options, the result is
> > completely meaningless.   Or is there a plan to make that work nicely?
> >
>
> Currently, the paths to display in mount options are stored
> in ofs->config.lowerdirs array.
>
> Those paths could be invalid or point to different objects or not
> accessible from the mount namepsace by the time someone
> observes them in mount options, so there are not many guarantees
> about those displayed paths.
>
> We could use file_path() to resolve path strings of the moment in the
> mount namepsace of the mounter from the lowerdirfd files and store
> them in ofs->config.lowerdirs array.

Right, so the configuration would use fd's while the display would
fall back to string paths.  That makes sense.

> BTW, it looks like we also don't display the user passed lowerdir
> parameter as is in the case of escaped characters in lowerdirs.
> Admittedly, that is another change of behavior from the new mount
> api param parsers.

And it's a bug (regardless of being a regression or not) since commas
and whitespace  must be escaped on this interface, and colon too for
being a separator of lower layers.

More fun: upperdir and workdir use seq_show_option() which escapes
commas and whitespace, so any escaped characters during mount will end
up being double escaped.

Obviously this domain is severely undertested.

Thanks,
Miklos
