Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57677C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 19:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiCaTHa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 15:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbiCaTH3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 15:07:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEDEA21C068
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 12:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648753540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1J66zwURshD+9na9PWXWfzlKh4xKyKxIgsoaQIEPO1c=;
        b=jNlaqHD51wt2ka73UtYijhEmTlmd6EYavEUPmDLgOusnanchesmHQmVocRvEwyQyYRLR5k
        J3vVs46Ptp21c0FvU2Vvk5RZPvMc5HWhJD5WxbGf9mtOF2AArqGCfx+Z6/SCRAoL6yz6tN
        FcqCyR6A3gC9HWEMfkBBLEWfQM6mSts=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-FAr7BTzyOhSuyLDlIFxpfw-1; Thu, 31 Mar 2022 15:05:35 -0400
X-MC-Unique: FAr7BTzyOhSuyLDlIFxpfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 889B1380391C;
        Thu, 31 Mar 2022 19:05:34 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.32.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 299A62166B26;
        Thu, 31 Mar 2022 19:05:34 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id CA88A220EFF; Thu, 31 Mar 2022 15:05:33 -0400 (EDT)
Date:   Thu, 31 Mar 2022 15:05:33 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v3 00/19] overlay: support idmapped layers
Message-ID: <YkX7fdIE+B3Z+Ze2@redhat.com>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 31, 2022 at 01:22:58PM +0200, Christian Brauner wrote:

Hi Christian,

Following the example in here.

https://gitlab.com/brauner/fs.idmapped.overlay.xfstests.output/-/blob/main/manual.test.instructions

sudo mount-idmapped --map-mount b:10000000:0:100000000000 ./my-tmp /mnt

Initially I could not even create idmapped mounts. I had to specify
full path and then it works. But relative path (./my-tmp) does not
work.

For example this works.

/root/git/xfstests-dev/src/idmapped-mounts/mount-idmapped --map-mount b:10000000:0:100000000000 /root/idmapped-testing/my-tmp /root/idmapped-testing/shifted

But this fails.

$ /root/git/xfstests-dev/src/idmapped-mounts/mount-idmapped --map-mount b:10000000:0:100000000000 ./my-tmp shifted

Bad file descriptor - Failed to open ./my-tmp

Not sure if this is a limitation of idmapped-mounts or this is expected.

Thanks
Vivek

