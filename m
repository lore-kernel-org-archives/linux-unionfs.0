Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECD7C76188
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Apr 2023 14:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbjDEOG7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 10:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbjDEOGl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Apr 2023 10:06:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2A7659A
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Apr 2023 07:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680703334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=net1/YQpLyeedtAUAtKmhMoSFz+7An5MzKe0V2cpLas=;
        b=ckchfDaswZqr2jOOzGRRkrtwF+7vq5SpjseThpUHpCtEqlUdGdLKFYFTteNTBoAIasLjlJ
        VqjtF00gB5nJoG3leYh+iDHQlyvgWc9tBhGoebVYSh/SodYplfZ/rgih5QZUWfngIBB2Gg
        IUVCMWOoosqg++nz1/JjEld4EJTmU9c=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-e3_QrPWZM0Okdh3ohtSdLg-1; Wed, 05 Apr 2023 10:02:12 -0400
X-MC-Unique: e3_QrPWZM0Okdh3ohtSdLg-1
Received: by mail-pj1-f71.google.com with SMTP id q30-20020a17090a17a100b0023d376ac2c5so9631931pja.5
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Apr 2023 07:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680703331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=net1/YQpLyeedtAUAtKmhMoSFz+7An5MzKe0V2cpLas=;
        b=3yHi6q7PBkwJIw/zMIjDCuCynXCl8AdBuj1nSL7/5ZRoFHvJezo3Uoac0jDNzmuWvS
         klZmCpcSqKxK7CWCt5As0/VMqvTdmeRflzk0OZj4NrtJoitXRY9Zy0iIGgpcTWJoa8QL
         IOvm50IqOwFYo1XeE5eXUh74Wg+fh3CkJw3gp/kiTH18ZLCatFs758htOuEmqBUTnvLS
         t071Wnvl+v0RdbjaxKjLkuvxarSN1O/Z8zpPPuvMmPsiOaqTWUzsyQxkIpo4hwFj/C6C
         LtvrHKAsCo8V2U80BimNeR1C9c2h3APmJOc/LcvyKLqbcvcNxRaNQr2fCPYyn1q7Ih6t
         3GeA==
X-Gm-Message-State: AAQBX9eXJ8i06d6T2IrRp5GVElujWdy1Y7U/SRSt3lP6PV5wMpAQPCMW
        zOOrvyVaEEg6M5lUKymP1/Ft73Qb60UNuPU5C53IJN6WnhWpDYE5twUcTLB0salixMuFMagy3YX
        ZgYR+w1VNnIO3RFgFHWZwFoionQ==
X-Received: by 2002:a17:903:283:b0:1a1:cd69:d301 with SMTP id j3-20020a170903028300b001a1cd69d301mr6292237plr.68.1680703330931;
        Wed, 05 Apr 2023 07:02:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z3hrO2tDczikPPadND/siCWP3StMDF6ZwRfuQDU1LtW+SuQXatmasFWBRAsAV4qHbVdUEpFA==
X-Received: by 2002:a17:903:283:b0:1a1:cd69:d301 with SMTP id j3-20020a170903028300b001a1cd69d301mr6292202plr.68.1680703330583;
        Wed, 05 Apr 2023 07:02:10 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b24-20020a630c18000000b005023496e339sm9037285pgl.63.2023.04.05.07.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:02:10 -0700 (PDT)
Date:   Wed, 5 Apr 2023 22:02:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        brauner@kernel.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        linux-unionfs@vger.kernel.org, anand.jain@oracle.com,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        fdmanana@suse.com, jack@suse.com, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] fstests/MAINTAINERS: add supported mailing list
Message-ID: <20230405140202.bdp3lzgross2cjbt@zlang-mailbox>
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
 <20230404221653.GC1893@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404221653.GC1893@sol.localdomain>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 04, 2023 at 03:16:53PM -0700, Eric Biggers wrote:
> Hi Zorro,
> 
> On Wed, Apr 05, 2023 at 01:14:09AM +0800, Zorro Lang wrote:
> > +FSVERITY
> > +L:	fsverity@lists.linux.dev
> > +S:	Supported
> > +F:	common/verity
> > +
> > +FSCRYPT
> > +L:      linux-fscrypt@vger.kernel.org
> > +S:	Supported
> > +F:	common/encrypt
> 
> Most of the encrypt and verity tests are in tests/generic/ and are in the
> 'encrypt' or 'verity' test groups.
> 
> These file patterns only pick up the common files, not the actual tests.
> 
> Have you considered adding a way to specify maintainers for a test group?
> Something like:
> 
>     G:      encrypt
> 
> and
> 
>     G:      verity

Good idea! Let's check if this patchset is acceptable by most of you,
then I'll think about how to add this feature later.

Thanks,
Zorro

> 
> - Eric
> 

