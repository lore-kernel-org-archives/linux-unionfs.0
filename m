Return-Path: <SRS0=/7Q0=6L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E973C54FD0
	for <linux-unionfs@archiver.kernel.org>; Mon, 27 Apr 2020 09:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9FE206BF
	for <linux-unionfs@archiver.kernel.org>; Mon, 27 Apr 2020 09:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MawHmgqx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgD0J7H (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 05:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbgD0J7G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Apr 2020 05:59:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE4BC061BD3;
        Mon, 27 Apr 2020 02:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=yzeRVcY/jiMjgzie19VzRu80wjYL6T4QqSNhy7ti850=; b=MawHmgqx3ntwabmTVIFoBBdB1g
        fLrw4cpQxf4WZXzAnPGzo8i+HRx5EZ20yTKoQHW4VSbKQwtcyGZu4x5SgndpmyAG+Zg+bEYrWBDkf
        J9hUE6bDmPbIAJGmORKxOW25J51EFzY63o1aFUJ5Y8smbiT9opupYZ9dJ1KxQsrfoZAu6Wzc47xFS
        FISW+qEFnva+VPCQvnNMATamtNG9lVSJED3DF+1REMJ+1NoXz3y+ghDBKS2qp1ZuD0WFGA0KcNDFD
        GqAaSFbeDvCl8OGa7nT8ABXT4EN2uCnWnapZlvcJDFtKfZ3ZdD9dUxd/u35vnLaIRbPh8yDzHkOqa
        eUed9dAg==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT0XU-0003eX-Ry; Mon, 27 Apr 2020 09:59:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk
Cc:     jack@suse.cz, tytso@mit.edu, adilger@dilger.ca,
        riteshh@linux.ibm.com, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: fix fiemap for ext4 bitmap files (+ cleanups)
Date:   Mon, 27 Apr 2020 11:58:50 +0200
Message-Id: <20200427095858.1440608-1-hch@lst.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi all,

the first two patches should fix the issue where ext4 doesn't
properly check the max file size for bitmap files in fiemap.

The rest cleans up the fiemap support in ext4 and in general.
