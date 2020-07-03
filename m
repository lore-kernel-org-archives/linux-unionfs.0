Return-Path: <SRS0=HCnm=AO=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EDEC433E1
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Jul 2020 21:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5A120885
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Jul 2020 21:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DYk4ml3k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGCVoD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 17:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgGCVoB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Jul 2020 17:44:01 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DD3C061794;
        Fri,  3 Jul 2020 14:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QYt3pLrvEkgdE5J9HL0HcJrm5k49qsMnkbwk8AJ+Pa4=; b=DYk4ml3k/OpYg3wEdP54cuw5kr
        9boTO/p72S7yr71IB6JW1UzHP60tl2Rjpizt8RMtwF/N+xBTrN/W43HOaKN7e/KUAlKoWB18QOBGd
        4HJZTZ7ziQNpfeu2fN/PcKVghE+Y45mLZGCntE7MFVoTk+9DXhBS+VqbOUNF2dLgx5EvJOKa9EAvR
        BFLuKH6X7/OrHc2z2e3CwCxWdlHV5roAefwDtQMbQbcN+J/KMVXX/j6y8ljQqa3QBTtaOeSrdQHx7
        9/JSu6jVUxiH8uZayeLZMvfnbKE5ET4/3GgZrnomJyH2UWYzO6pCIOvmp+Tj9pc8cVvEX3arI9ZRg
        btS/XlIg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrTTS-0006uZ-Ch; Fri, 03 Jul 2020 21:43:58 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com,
        Joel Becker <jlbec@evilplan.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 05/10] Documentation: filesystems: fsverity: drop doubled word
Date:   Fri,  3 Jul 2020 14:43:20 -0700
Message-Id: <20200703214325.31036-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703214325.31036-1-rdunlap@infradead.org>
References: <20200703214325.31036-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Drop the doubled word "the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Y. Ts'o <tytso@mit.edu>
Cc: linux-fscrypt@vger.kernel.org
---
 Documentation/filesystems/fsverity.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/filesystems/fsverity.rst
+++ linux-next-20200701/Documentation/filesystems/fsverity.rst
@@ -659,7 +659,7 @@ weren't already directly answered in oth
       retrofit existing filesystems with new consistency mechanisms.
       Data journalling is available on ext4, but is very slow.
 
-    - Rebuilding the the Merkle tree after every write, which would be
+    - Rebuilding the Merkle tree after every write, which would be
       extremely inefficient.  Alternatively, a different authenticated
       dictionary structure such as an "authenticated skiplist" could
       be used.  However, this would be far more complex.
