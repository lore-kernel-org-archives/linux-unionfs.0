Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F9CE81DF5
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Oct 2023 13:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjJFNDr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 09:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjJFNDq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2023 09:03:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4B4114
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Oct 2023 06:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696597384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKnhccefNOC2jW196YWWzcax7x6EquPRWESLg+qSrJY=;
        b=Cokv2GVMGc+JU+42yFwe8WOsHt0oVsjSv2V94RhO94wwyNapc2n2xSFh7KFUFjykbZKM/P
        rwHTg0JIaAbimUkRaaWKezzr726kE8Bb38Lm2J7t/PQmEQmdeBpnKv21Behl5V59iQAIAI
        t6y8uwF0Oa16dnCUJgCrEp+oMyuODiU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-k8YVAfvgPqO2s8m-LV64ww-1; Fri, 06 Oct 2023 09:03:02 -0400
X-MC-Unique: k8YVAfvgPqO2s8m-LV64ww-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40647c6f71dso15328195e9.2
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2023 06:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696597381; x=1697202181;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKnhccefNOC2jW196YWWzcax7x6EquPRWESLg+qSrJY=;
        b=um+BpMprsOQ9wBGSGh1s6/W6DdmtRBSmqBd3uQWBPc/aUeQ3giA0cJ1FjVwzEv7mtG
         7W/KK2paNUkyOVEpt0rAYCreynq2etbo6lLkNQlCq7zG7Zvza9Pybj4VRDqAhofvq+iv
         sSahNRVmdhAHFf+6mxdPyOMdJVKtENhNyKEQN5Xt4Pw6LQzLmbzeJa/jWEP+1O43u1gs
         cfMdZCrsgqUW+rGYuRyOI00Z7z+Vtq0L+Up12GxdafCz0c2+btKH3BseVYljUh1s7wQ/
         1+6Xhz6clRdk/pecHbCST9DZdj4wsL9XT8iI2rUnWUQJr4NRGPPrOfZB4LYzhI9gPVSa
         GL9Q==
X-Gm-Message-State: AOJu0Yx+IaIfroF+h4DZR+nQWcBIHbvB/y1Vf6Pabux7d+AJ43AaKK7o
        zyZzDxKO1jsJzC8ddx1i5ncM2pVa4sTZTp7HRRyyBJSI40QI2NBg3hv7XnLCNjRQXPDMBSI60ZC
        dIYxPpZRH6sfeE52cS/8ytabnDA==
X-Received: by 2002:a05:600c:294a:b0:3f5:fff8:d4f3 with SMTP id n10-20020a05600c294a00b003f5fff8d4f3mr7706415wmd.7.1696597381728;
        Fri, 06 Oct 2023 06:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEn1OEL10h8YaSWdld1yKYl7xR3rohSvMPIxldWVOJi0G1MBn/lSClR5EbuYeFbxj7Rq9/Ww==
X-Received: by 2002:a05:600c:294a:b0:3f5:fff8:d4f3 with SMTP id n10-20020a05600c294a00b003f5fff8d4f3mr7706387wmd.7.1696597381080;
        Fri, 06 Oct 2023 06:03:01 -0700 (PDT)
Received: from toolbox ([2001:9e8:89bc:cf00:7c0e:f203:f32:6eaf])
        by smtp.gmail.com with ESMTPSA id i14-20020a05600c354e00b004068de50c64sm3599166wmq.46.2023.10.06.06.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 06:03:00 -0700 (PDT)
Date:   Fri, 6 Oct 2023 15:02:59 +0200
From:   Sebastian Wick <sebastian.wick@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [regression?] escaping commas in overlayfs mount options
Message-ID: <20231006130259.GA438068@toolbox>
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 29, 2023 at 07:44:09AM +0300, Amir Goldstein wrote:
> On Fri, Sep 29, 2023 at 4:08 AM Ryan Hendrickson
> <ryan.hendrickson@alum.mit.edu> wrote:
> >
> > Up to and including kernel 6.4.15, it was possible to have commas in
> > the lowerdir/upperdir/workdir paths used by overlayfs, provided they were
> > escaped with backslashes:
> >
> >      mkdir /tmp/test-lower, /tmp/test-upper /tmp/test-work /tmp/test
> >      mount -t overlay overlay -o 'lowerdir=/tmp/test-lower\,,upperdir=/tmp/test-upper,workdir=/tmp/test-work' /tmp/test
> >
> > In 6.5.2 and 6.5.5, this no longer works; dmesg reports that overlayfs
> > can't resolve '/tmp/test-lower' (without the comma).
> >
> > I see that there is a commit between the 6.4 and 6.5 lines titled [ovl:
> > port to new mount api][1]. I haven't compiled a kernel before and after
> > this commit to verify, but based on the code it deletes I strongly suspect
> > that it, or if not then one of the ovl commits committed on the same day,
> > is responsible for this change.
> >
> > [1]: https://github.com/torvalds/linux/commit/1784fbc2ed9c888ea4e895f30a53207ed7ee8208
> >
> 
> That's a good guess.
> It helps to CC the author of the patch in this case ;-)
> 
> > Does this count as a regression?
> 
> "used to work, does not work now" is pretty close to a dictionary
> definition of a regression :)
> 
> The question is whether we should fix it.
> The rule of thumb is that if users complain than we need to fix it,
> but it's a corner case and if the only users that complained are willing
> to work around the problem (hint hint) then we may not need to fix it.

It would be nice to have this fixed. A more general question: will you
commit on keeping the escaping stable from now on or do we have to
expect changes at any point in the future?

In that case we would just reject any string contianing characters that
need escaping.

> > I can't find documentation for this
> > escaping feature anywhere, even as it pertains to the non-comma characters
> > '\\' and ':' (which, I've tested, can still be escaped as expected), so
> > perhaps it was never properly supported? But a search for escaping commas
> > in overlayfs turns up resources like [this post][2], suggesting that there
> > are others who figured this out and expect it to work.
> >
> > [2]: https://unix.stackexchange.com/a/552640
> >
> > Is there a new way to escape commas for overlayfs options?
> >
> 
> Deferring the question to Christian.
> 
> Thanks,
> Amir.

