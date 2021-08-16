Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887D6C4338F
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Aug 2021 19:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C77160F4B
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Aug 2021 19:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhHPTuP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Aug 2021 15:50:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhHPTuP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Aug 2021 15:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629143382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeZs2Vbi3LPUYE5L2DmMtSeAlr7D2lLP2ZjOK1a2vac=;
        b=HcAhnYyP4FbrhXC7An5Q97M9jPie4Get/ygnVW6+OHVecje+5IgNKkKRC9gX+dyt7UJs3b
        pkcGHZ4rWhqMjOxhov2WhcDVkRp6HnoTPWhaseVu8tsptEuJR+/ySso0Cy40ll/jyoeuIW
        dOQq+lxm/ghyhq3jt/K7o2+WsIBzr40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-jFjNC1f-ORu85GVvshofLw-1; Mon, 16 Aug 2021 15:49:41 -0400
X-MC-Unique: jFjNC1f-ORu85GVvshofLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC71C871807;
        Mon, 16 Aug 2021 19:49:40 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 874FF18017;
        Mon, 16 Aug 2021 19:49:05 +0000 (UTC)
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
        Michal Hocko <mhocko@suse.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= 
        <ckoenig.leichtzumerken@gmail.com>,
        Florian Weimer <fweimer@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org,
        x86@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 1/7] binfmt: don't use MAP_DENYWRITE when loading shared libraries via uselib()
Date:   Mon, 16 Aug 2021 21:48:34 +0200
Message-Id: <20210816194840.42769-2-david@redhat.com>
In-Reply-To: <20210816194840.42769-1-david@redhat.com>
References: <20210816194840.42769-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

uselib() is the legacy systemcall for loading shared libraries.
Nowadays, applications use dlopen() to load shared libraries, completely
implemented in user space via mmap().

For example, glibc uses MAP_COPY to mmap shared libraries. While this
maps to MAP_PRIVATE | MAP_DENYWRITE on Linux, Linux ignores any
MAP_DENYWRITE specification from user space in mmap.

With this change, all remaining in-tree users of MAP_DENYWRITE use it
to map an executable. We will be able to open shared libraries loaded
via uselib() writable, just as we already can via dlopen() from user
space.

This is one step into the direction of removing MAP_DENYWRITE from the
kernel. This can be considered a minor user space visible change.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/x86/ia32/ia32_aout.c | 2 +-
 fs/binfmt_aout.c          | 2 +-
 fs/binfmt_elf.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 5e5b9fc2747f..321d7b22ad2d 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -293,7 +293,7 @@ static int load_aout_library(struct file *file)
 	/* Now use mmap to map the library into memory. */
 	error = vm_mmap(file, start_addr, ex.a_text + ex.a_data,
 			PROT_READ | PROT_WRITE | PROT_EXEC,
-			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_32BIT,
+			MAP_FIXED | MAP_PRIVATE | MAP_32BIT,
 			N_TXTOFF(ex));
 	retval = error;
 	if (error != start_addr)
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 145917f734fe..d29de971d3f3 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -309,7 +309,7 @@ static int load_aout_library(struct file *file)
 	/* Now use mmap to map the library into memory. */
 	error = vm_mmap(file, start_addr, ex.a_text + ex.a_data,
 			PROT_READ | PROT_WRITE | PROT_EXEC,
-			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
+			MAP_FIXED | MAP_PRIVATE;
 			N_TXTOFF(ex));
 	retval = error;
 	if (error != start_addr)
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 439ed81e755a..6d2c79533631 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1384,7 +1384,7 @@ static int load_elf_library(struct file *file)
 			(eppnt->p_filesz +
 			 ELF_PAGEOFFSET(eppnt->p_vaddr)),
 			PROT_READ | PROT_WRITE | PROT_EXEC,
-			MAP_FIXED_NOREPLACE | MAP_PRIVATE | MAP_DENYWRITE,
+			MAP_FIXED_NOREPLACE | MAP_PRIVATE,
 			(eppnt->p_offset -
 			 ELF_PAGEOFFSET(eppnt->p_vaddr)));
 	if (error != ELF_PAGESTART(eppnt->p_vaddr))
-- 
2.31.1

