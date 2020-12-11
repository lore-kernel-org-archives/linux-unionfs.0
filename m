Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E864C4361B
	for <linux-unionfs@archiver.kernel.org>; Sat, 12 Dec 2020 00:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06956221F5
	for <linux-unionfs@archiver.kernel.org>; Sat, 12 Dec 2020 00:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393665AbgLKXvz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 18:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437464AbgLKXv2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Dec 2020 18:51:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCBBC0617A7
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Dec 2020 15:50:13 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w16so8224756pga.9
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Dec 2020 15:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sWr4dlswm/DRNu6GTIuObFvq9ZljqhYX8xwv7K9hdSQ=;
        b=jqQ0QIg7eKKpcLBX+VXe3oiPkcuw6okzb/PvhUNHkBLSDGxy6KT18KvgIoncC8UKwY
         Zggcf9dTdzz4N6TUG/ZJgGi6WT+ZjERt1kNeYu/uSf1GrcOCDPRdp/I2xkhjvLj+fxPi
         VSXyI+uL+yHsTH+1WNkFUGj9Y50ODIY6PlH6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sWr4dlswm/DRNu6GTIuObFvq9ZljqhYX8xwv7K9hdSQ=;
        b=mRldcrOA7rNVWPrSz2U/DLnhRtZxCX+a3M2G4gaQBGmfrP9ZGHqCdgL7EsUAVTfRhZ
         GJbsG2u5kPn/kawleNpYX78+qLOXYd0Dyc/jIbxJnq+Tbh6lkwYy2n41bET9+S/ari3a
         uFB/jJ1zSNMhMo0UZQFh3SRLBc3eqEEi39gWBwNCQ5PDKw0GdLVo5TzPWdWE7nRTvbs3
         282nPG4lLAs+71NZEPe+ZDgcBL07avgR5vN5XEYfkJwDWsWk7Po9yFIGNkXYAs4Y/es2
         q7NIPPsWa7T4HhlKfnk8rcqtPIWGvPxYI8WwTZQOZScOwM5WwZAeUSeGH+QaiKDYkaye
         qgjw==
X-Gm-Message-State: AOAM531CeSZyruUXSyeHKa0aHn2yId0hIDSQNPYsQSGzcMm7ga9Zx410
        7cpGZLO8GMgsjjRtKiN3KWnWbA==
X-Google-Smtp-Source: ABdhPJxIK3BkR45TwQEgkdprgBAjp4tW7Ab+Doh1jVf0TGCBwxsXrQzrE660WhUEwngMr/jDDlKC1g==
X-Received: by 2002:a05:6a00:a91:b029:19d:9421:847 with SMTP id b17-20020a056a000a91b029019d94210847mr4722715pfl.72.1607730612912;
        Fri, 11 Dec 2020 15:50:12 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id b12sm11324641pft.114.2020.12.11.15.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 15:50:12 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     Sargun Dhillon <sargun@sargun.me>, Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 2/3] errseq: Add mechanism to snapshot errseq_counter and check snapshot
Date:   Fri, 11 Dec 2020 15:50:01 -0800
Message-Id: <20201211235002.4195-3-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211235002.4195-1-sargun@sargun.me>
References: <20201211235002.4195-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This adds the function errseq_counter_sample to allow for "subscribers"
to take point-in-time snapshots of the errseq_counter, and store the
counter + errseq_t.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 include/linux/errseq.h |  4 ++++
 lib/errseq.c           | 51 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/errseq.h b/include/linux/errseq.h
index 35818c484290..8998df499a3b 100644
--- a/include/linux/errseq.h
+++ b/include/linux/errseq.h
@@ -25,4 +25,8 @@ errseq_t errseq_set(errseq_t *eseq, int err);
 errseq_t errseq_sample(errseq_t *eseq);
 int errseq_check(errseq_t *eseq, errseq_t since);
 int errseq_check_and_advance(errseq_t *eseq, errseq_t *since);
+void errseq_counter_sample(errseq_t *dst_errseq, int *dst_errors,
+			   struct errseq_counter *counter);
+int errseq_counter_check(struct errseq_counter *counter, errseq_t errseq_since,
+			 int errors_since);
 #endif
diff --git a/lib/errseq.c b/lib/errseq.c
index d555e7fc18d2..98fcfafa3d97 100644
--- a/lib/errseq.c
+++ b/lib/errseq.c
@@ -246,3 +246,54 @@ int errseq_check_and_advance(errseq_t *eseq, errseq_t *since)
 	return err;
 }
 EXPORT_SYMBOL(errseq_check_and_advance);
+
+/**
+ * errseq_counter_sample() - Grab the current errseq_counter value
+ * @dst_errseq: The errseq_t to copy to
+ * @dst_errors: The destination overflow to copy to
+ * @counter: The errseq_counter to copy from
+ *
+ * Grabs a point in time sample of the errseq_counter for latter comparison
+ */
+void errseq_counter_sample(errseq_t *dst_errseq, int *dst_errors,
+			   struct errseq_counter *counter)
+{
+	errseq_t cur;
+
+	do {
+		cur = READ_ONCE(counter->errseq);
+		*dst_errors = atomic_read(&counter->errors);
+	} while (cur != READ_ONCE(counter->errseq));
+
+	/* Clear the seen bit to make checking later easier */
+	*dst_errseq = cur & ~ERRSEQ_SEEN;
+}
+EXPORT_SYMBOL(errseq_counter_sample);
+
+/**
+ * errseq_counter_check() - Has an error occurred since the sample
+ * @counter: The errseq_counter from which to check.
+ * @errseq_since: The errseq_t sampled with errseq_counter_sample to check
+ * @errors_since: The errors sampled with errseq_counter_sample to check
+ *
+ * Returns: The latest error set in the errseq_t or 0 if there have been none.
+ */
+int errseq_counter_check(struct errseq_counter *counter, errseq_t errseq_since,
+			 int errors_since)
+{
+	errseq_t cur_errseq;
+	int cur_errors;
+
+	cur_errors = atomic_read(&counter->errors);
+	/* To match the barrier in errseq_counter_set */
+	smp_rmb();
+
+	/* Clear / ignore the seen bit as we do at sample time */
+	cur_errseq = READ_ONCE(counter->errseq) & ~ERRSEQ_SEEN;
+
+	if (cur_errseq == errseq_since && errors_since == cur_errors)
+		return 0;
+
+	return -(cur_errseq & MAX_ERRNO);
+}
+EXPORT_SYMBOL(errseq_counter_check);
-- 
2.25.1

