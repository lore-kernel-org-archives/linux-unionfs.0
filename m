Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB11C432BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 945026103A
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhHLIrE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:47:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232784AbhHLIrE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Aug 2021 04:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628757999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i29czw9Qyxt5GRshhvU4+ALP+14hXV/6g5fULUW9cSo=;
        b=HDF0Dly19kBjq4Kf1pM+NFg2v5zQpcIV/Z9qYyjmob3NBks98u4muupNlpdIMxWjThXbcg
        qDV4WWF4Aw7cb/pYkAQWnDjPzPRMiS/qnlBsmofw40nFr2qZIuy8o5tZ6t/qF1aiSId4ks
        LEdyo5aRQy/VYqtGDIJxnMVSPBRvqfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-YXqT7uE3O-CAxB4sXefWdg-1; Thu, 12 Aug 2021 04:46:36 -0400
X-MC-Unique: YXqT7uE3O-CAxB4sXefWdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C417107ACF5;
        Thu, 12 Aug 2021 08:46:34 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A840B5C3E0;
        Thu, 12 Aug 2021 08:46:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Rapoport <rppt@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Chinwen Chang <chinwen.chang@mediatek.com>,
        Michel Lespinasse <walken@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Jann Horn <jannh@google.com>, Feng Tang <feng.tang@intel.com>,
        Kevin Brodsky <Kevin.Brodsky@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shawn Anastasio <shawn@anastas.io>,
        Steven Price <steven.price@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Marco Elver <elver@google.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Nicolas Viennot <Nicolas.Viennot@twosigma.com>,
        Thomas Cedeno <thomascedeno@google.com>,
        Collin Fijalkovich <cfijalkovich@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= 
        <ckoenig.leichtzumerken@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v1 7/7] fs: update documentation of get_write_access() and friends
Date:   Thu, 12 Aug 2021 10:43:48 +0200
Message-Id: <20210812084348.6521-8-david@redhat.com>
In-Reply-To: <20210812084348.6521-1-david@redhat.com>
References: <20210812084348.6521-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

As VM_DENYWRITE does no longer exists, let's spring-clean the
documentation of get_write_access() and friends.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/fs.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 640574294216..e0dc3e96ed72 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3055,15 +3055,20 @@ static inline void file_end_write(struct file *file)
 }
 
 /*
+ * This is used for regular files where some users -- especially the
+ * currently executed binary in a process, previously handled via
+ * VM_DENYWRITE -- cannot handle concurrent write (and maybe mmap
+ * read-write shared) accesses.
+ *
  * get_write_access() gets write permission for a file.
  * put_write_access() releases this write permission.
- * This is used for regular files.
- * We cannot support write (and maybe mmap read-write shared) accesses and
- * MAP_DENYWRITE mmappings simultaneously. The i_writecount field of an inode
- * can have the following values:
- * 0: no writers, no VM_DENYWRITE mappings
- * < 0: (-i_writecount) vm_area_structs with VM_DENYWRITE set exist
- * > 0: (i_writecount) users are writing to the file.
+ * deny_write_access() denies write access to a file.
+ * allow_write_access() re-enables write access to a file.
+ *
+ * The i_writecount field of an inode can have the following values:
+ * 0: no write access, no denied write access
+ * < 0: (-i_writecount) users that denied write access to the file.
+ * > 0: (i_writecount) users that have write access to the file.
  *
  * Normally we operate on that counter with atomic_{inc,dec} and it's safe
  * except for the cases where we don't hold i_writecount yet. Then we need to
-- 
2.31.1

