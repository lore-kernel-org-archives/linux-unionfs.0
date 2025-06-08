Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B22451C3
	for <linux-unionfs@vger.kernel.org>; Sun,  8 Jun 2025 13:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749388588; cv=none; b=blcU6dtcx5WOloHNqpDXxDtN08BwqsSlBCZM3nmCZ+jD1LMzOqAFz55EduQgRigogogJdv9e/bfSZJ9cdOtcAQ+iwpGio5eot677Ov2H7sx5un/xnnsx65DyVOiOXICFg+8cx6Ude7FaLRlgl+ICI0EHShI8WoGxCjI867JDWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749388588; c=relaxed/simple;
	bh=z5Rb9NaOorelcpOOmYbHt5U2BUKoUix67idI9T/2vJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsjEISd/BOTM0OOmkcYCt+1VenfWklcWUa5m5S6jkVPB5v0Rels+1Mi+tA4JPTr2zWQJgOONKXxChOH1Xcx+TPZGoQcfjemC/6a/5tNFWq7oSgfFhl1LFbwVaIdcJWKW4/H76zLk1sQqbIED6hGT+MUo1bfQJzqKNvzry0C8qGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJhqPumQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJhqPumQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749388584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TFburNEhInKXG/A3BJhU5nsx+v2WT6nnYGCasvpEeTw=;
	b=OJhqPumQcKHRx1YlJhlq+0yRDEClUjDWx5/l5c3RmrKuLp9U8chFCWIg84+76FobmEy83J
	eOT0zAkWFLNPGfU0FrJL0IIO8faI0iobEJVUN0aP+ebyTbUel1BU3pSsEZ8MNMSmubUzik
	HStFa2fjpZvz8+THRxCV7Tbuo/Ismwg=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-tpJnw63CPCqJA_K0FVkFlQ-1; Sun, 08 Jun 2025 09:16:22 -0400
X-MC-Unique: tpJnw63CPCqJA_K0FVkFlQ-1
X-Mimecast-MFC-AGG-ID: tpJnw63CPCqJA_K0FVkFlQ_1749388581
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-747a9ef52a4so4782634b3a.2
        for <linux-unionfs@vger.kernel.org>; Sun, 08 Jun 2025 06:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749388581; x=1749993381;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TFburNEhInKXG/A3BJhU5nsx+v2WT6nnYGCasvpEeTw=;
        b=FzDvBKhuDNqLe1ZPfv4TG2QrlXeVXPFzByS9LT3QPhs58LiIpJHcLFKR8duIJXc5Cd
         UG9E2mjtjp0CIY6KsGYqUZ6jj1TgQIlh/aZoBFTvWQiW0O+uaYT1nP1287gAMmI8xdn/
         yYDG9PPv7AUXJOZp/SS8uoPUYcwbhIb61/OFGWkH96eQJ9gJY0d6kVmBAJqn0Pf7QA46
         iSD9J/PCCsL3qc9IyQ2/SXg89oDq/p0n1AHaB0xYJ634YEyC0cQ9e0g3ZsNrsCL2P1/A
         crjYWs4qu62Bf6XXmw/zchR12OMMN5eT8twa0b9t9MF8JQuxPPycBX14DvwNswIh19Gs
         nIlg==
X-Forwarded-Encrypted: i=1; AJvYcCWG923fd1ZylxA+GqwbfrL2FffqObB2/FWH4i87QWptkHLwGw9rI00d4hXgbhiAweWbHfV2shfADrPeTROM@vger.kernel.org
X-Gm-Message-State: AOJu0YyeaDcy3ucsj1M//PWekBXEYvEOcEUbnteUgaxPL5eMyDeOdffR
	geLDTPYXBtIqGm7Y8ggjSDbvSNeIQvjygvbnS+7oitCfMfLJwvgkxSFyOqh9zxVkFSbGQHnBCL+
	+u8dHXgAc/yA+IAVixZcoyYCR+/YCRxlnIhoPpH/LjvCQvrDChfOFCw9a6wK290xpsV0=
X-Gm-Gg: ASbGnctC+dhDw3BbAe4LGUZxF7IVhTACd2RYF9CEfLb7gZcDc3XU7NG1lFge9PUiXxw
	nSruV/PN0t6R8FWTDAn2uT3TiocLRt8+2YslWbtwOr0hx4px/34sRJkNbSkcUWo4Bmhy3jUX4pP
	J0sOtIi7qfESqAtxUN/rF3r70jqDTHaneR1xKQL+DvKjKPfKo7gG9Wp9kJTwLrDz0x9SI/umRnK
	h6ciOWy57ZhBr73dbpMnACwCAgR8Ct1uTHJEI3ee+9m/1KhQpcNgiosfvoTOxovqzDWNP5xQTEJ
	wlpofaUyCktq01fvxupgwL8CKiuK6YzvXpJ0gfgBDjoo0TQpkGwC
X-Received: by 2002:a05:6a20:d80d:b0:1f5:8a1d:3904 with SMTP id adf61e73a8af0-21ee684e093mr15456109637.7.1749388581387;
        Sun, 08 Jun 2025 06:16:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7meP8uCoSTs1izDHbmybR1fOFujEYC9T171jMFXC1gGgc/31j4hZBqlOEC3LQvQNc285TBw==
X-Received: by 2002:a05:6a20:d80d:b0:1f5:8a1d:3904 with SMTP id adf61e73a8af0-21ee684e093mr15456077637.7.1749388581003;
        Sun, 08 Jun 2025 06:16:21 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af7ab1fsm4175922b3a.54.2025.06.08.06.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jun 2025 06:16:20 -0700 (PDT)
Date: Sun, 8 Jun 2025 21:16:16 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
Message-ID: <20250608131616.xf4dx2zwcwbapya3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
 <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
 <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhwi9qF-j_XiTQCCy-OH77X2SG6_CGngUqUFfXz1X-SuA@mail.gmail.com>

On Fri, Jun 06, 2025 at 02:12:21PM +0200, Amir Goldstein wrote:
> On Fri, Jun 6, 2025 at 12:29 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Fri, Jun 06, 2025 at 09:23:26AM +0200, Amir Goldstein wrote:
> > > On Fri, Jun 6, 2025 at 3:45 AM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Thu, Jun 05, 2025 at 08:38:30PM +0200, Amir Goldstein wrote:
> > > > > On Thu, Jun 5, 2025 at 7:32 PM Zorro Lang <zlang@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> > > > > > > This test performs shutdown via xfs_io -c shutdown.
> > > > > > >
> > > > > > > Overlayfs tests can use _scratch_shutdown, but they cannot use
> > > > > > > "-c shutdown" xfs_io command without jumping through hoops, so by
> > > > > > > default we do not support it.
> > > > > > >
> > > > > > > Add this condition to _require_xfs_io_command and add the require
> > > > > > > statement to test generic/623 so it wont run with overlayfs.
> > > > > > >
> > > > > > > Reported-by: André Almeida <andrealmeid@igalia.com>
> > > > > > > Tested-by: André Almeida <andrealmeid@igalia.com>
> > > > > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> > > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > > ---
> > > > > > >  common/rc         | 8 ++++++++
> > > > > > >  tests/generic/623 | 1 +
> > > > > > >  2 files changed, 9 insertions(+)
> > > > > > >
> > > > > > > diff --git a/common/rc b/common/rc
> > > > > > > index d8ee8328..bffd576a 100644
> > > > > > > --- a/common/rc
> > > > > > > +++ b/common/rc
> > > > > > > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> > > > > > >               touch $testfile
> > > > > > >               testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> > > > > > >               ;;
> > > > > > > +     "shutdown")
> > > > > > > +             if [ $FSTYP = "overlay" ]; then
> > > > > > > +                     # Overlayfs tests can use _scratch_shutdown, but they
> > > > > > > +                     # cannot use "-c shutdown" xfs_io command without jumping
> > > > > > > +                     # through hoops, so by default we do not support it.
> > > > > > > +                     _notrun "xfs_io $command not supported on $FSTYP"
> > > > > > > +             fi
> > > > > > > +             ;;
> > > > > >
> > > > > > Hmm... I'm not sure this's a good way.
> > > > > > For example, overlay/087 does xfs_io shutdown too,
> > > > >
> > > > > Yes it does but look at the effort needed to do that properly:
> > > > >
> > > > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
> > > > > ' -c close -c syncfs $SCRATCH_MNT | \
> > > > >         grep -vF '[00'
> > > > >
> > > > > > generally it should calls
> > > > > > _require_xfs_io_command "shutdown" although it doesn't. If someone overlay
> > > > > > test case hope to test as o/087 does, and it calls _require_xfs_io_command "shutdown",
> > > > > > then it'll be _notrun.
> > > > >
> > > > > If someone knows enough to perform the dance above with _scratch_shutdown_handle
> > > > > then that someone should know enough not to call
> > > > > _require_xfs_io_command "shutdown".
> > > > > OTOH, if someone doesn't know then default is to not run.
> > > >
> > > > Sure, I can understand that, just this logic is a bit *obscure* :) It sounds like:
> > > > "If an overlay test case wants to do xfs_io shutdown, it shouldn't call
> > > > _require_xfs_io_command "shutdown". Or call that to skip a shutdown test
> > > > on overlay :)"
> > > >
> > > > And the expected result of _require_xfs_io_command "shutdown" will be totally
> > > > opposite with _require_scratch_shutdown on overlay, that might be confused.
> > > > Can we have a clearer way to deal with that?
> > > >
> > >
> > > I don't really understand the confusion.
> > >
> > > _require_xfs_io_command "shutdown"
> > >
> > > Like any other _require statement
> > > requires support for what this test does -
> > > meaning that a test does xfs_io -c shutdown, just like test generic/623 does
> > >
> > > and _require_scratch_shutdown implies that the test does
> > > _scratch_shutdown
> > >
> > > FSTYP overlay happens to be able to do _scratch_shutdown
> > > but not able to do xfs_io -c shutdown $SCRATCH_MNT
> > >
> > > The different _require statements simply reflect reality as it is.
> > >
> > > We can solve the confused about o/087 not having
> > > _require_xfs_io_command "shutdown"
> > > by moving the special hand crafted xfs_io command in o/087
> > > to a helper _scratch_shutdown_and_syncfs to hide those internal
> > > implementation details from test writers.
> > > See attached patch.
> >
> > Hmm... give me a moment to order my thoughts step by step :)
> >
> > There're only 2 cases tend to do xfs_io shutdown on overlay currently
> > (others are xfs specific test cases):
> >
> >   $ grep -rsn shutdown tests/|grep -- "-c"
> >   tests/generic/623:29:$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> >   tests/overlay/087:50:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> >   tests/overlay/087:57:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> >   ...
> >
> > others shutdown cases nearly all use *_scratch_shutdown* with
> > *_require_scratch_shutdown*, these two functions are consistent in
> > code logic. And no one calls "_require_xfs_io_command shutdown" currently.
> >
> > So g/623 and o/087 are specifal, actually they call _require_scratch_shutdown
> > too, that makes sense for o/087. Now only g/623 doesn't make sense. Now we
> > need to help it to make sense.
> >
> > I think the key is in _require_scratch_shutdown function [1], how about add an
> > argument to clearly tell it we need to check shutdown "only on the top layer
> > $SCRATCH_MNT" or "try the lowest layer $BASE_SCRATCH_MNT if there is".
> >
> > For example:
> >
> > diff --git a/common/rc b/common/rc
> > index c3af8485c..5f30143e4 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4075,15 +4075,17 @@ _require_exportfs()
> >         _require_open_by_handle
> >  }
> >
> > -# Does shutdown work on this fs?
> > +# Does shutdown work on this [lower|top] layer fs?
> >  _require_scratch_shutdown()
> >  {
> > +       local layer="${1:-lower}"
> > +
> >         [ -x $here/src/godown ] || _notrun "src/godown executable not found"
> >
> >         _scratch_mkfs > /dev/null 2>&1 || _notrun "_scratch_mkfs failed on $SCRATCH_DEV"
> >         _scratch_mount
> >
> > -       if [ $FSTYP = "overlay" ]; then
> > +       if [ $FSTYP = "overlay" -a "$level" = "lower" ]; then
> >                 if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> >                         # In lagacy overlay usage, it may specify directory as
> >                         # SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
> > diff --git a/tests/generic/623 b/tests/generic/623
> > index b97e2adbe..af0f55397 100755
> > --- a/tests/generic/623
> > +++ b/tests/generic/623
> > @@ -15,7 +15,7 @@ _begin_fstest auto quick shutdown mmap
> >         "xfs: restore shutdown check in mapped write fault path"
> >
> >  _require_scratch_nocheck
> > -_require_scratch_shutdown
> > +_require_scratch_shutdown top
> 
> Sorry I find this utterly confusing.
> 
> Think of all the 95% of fstests developers that do not care about overlayfs
> what does this top mean to them and why should they use it for tests
> that do xfs_io -c shutdown and not for tests that do _scratch_shutdown?
> 
> The test author and reviewers should be able to look at the tests and
> easily derive what the test requirements should be according to simple rules.
> For example:
> 
> 1. A test that calls _scrash_shutdown needs to _require_scratch_shutdown
> 2. A test that calls _scratch_shutdown_and_syncfs needs to
> _require_scratch_shutdown_and_syncfs
> 3. A test that calls xfs_io -c shutdown needs to _require_xfs_io_shutdown
> 
> I completely understand why you do not like my hack of
> _require_xfs_io_command "shutdown"
> 
> Would you approve if it was an explicit _require_xfs_io_shutdown helper?
> 
> # Requirements for tests that call xfs_io -c shutdown instead of using the
> # _scratch_shutdown helper

OK, but you might metion that it's better not be used if _scratch_shutdown_handle
is called for xfs_io, as we hope the lower layer fs supports shutdown at that time:)

Actually I'm wondering if we should help xfstests to support BASE_FSTYP and FSTYP
for more upper layer fs, likes nfs, cifs, and so on. If so, overlay will not be
the only one fs who uses BASE_FSTYP and BASE_SCRATCH_DEV things, then we need to
differentiate if a feature (e.g. shutdown) is needed by upper layer fs or underlying
fs in a case.

...
BTW, a question which isn't belong to this patch:)  There're also some failures
from those xfstests overlay cases which run unionmount-testsuite (can't rememember
all, maybe o/102~109, o/144~117). The error (diff) output are similar as [1].
Is there a fix for that too? Or I missed the fix?

Thanks,
Zorro

[1]
--- /dev/fd/63	2025-06-07 05:16:59.489929312 -0400
+++ overlay/103.out.bad	2025-06-07 05:16:59.445716549 -0400
@@ -1,2 +1,17 @@
 QA output created by 103
+mount: /mnt/fstests/SCRATCH_DIR/union/m: wrong fs type, bad option, bad superblock on overlay, missing codepage or helper program, or other error.
+       dmesg(1) may have more information after failed mount system call.
+Traceback (most recent call last):
+  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/master/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/./run", line 362, in <module>
+    func(ctx)
+  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/master/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/tests/rename-file.py", line 71, in subtest_5
+    ctx.rename(f, f2)
+  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/master/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/context.py", line 1254, in rename
+    remount_union(self, rotate_upper=True)
+  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/master/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/remount_union.py", line 35, in remount_union
+    system(cmd)
+  File "/mnt/tests/gitlab.cee.redhat.com/kernel-qe/kernel/-/archive/master/kernel-master.tar.bz2/filesystems/xfstests/unionmount-testsuite/tool_box.py", line 25, in system
+    raise RuntimeError("Command failed: " + command)
+RuntimeError: Command failed: mount -t overlay overlay /mnt/fstests/SCRATCH_DIR/union/m -orw,xino=on -olowerdir=/mnt/fstests/SCRATCH_DIR/union/6/u:/mnt/fstests/SCRATCH_DIR/union/5/u:/mnt/fstests/SCRATCH_DIR/union/4/u:/mnt/fstests/SCRATCH_DIR/union/3/u:/mnt/fstests/SCRATCH_DIR/union/2/u:/mnt/fstests/SCRATCH_DIR/union/1/u:/mnt/fstests/SCRATCH_DIR/union/0/u:/mnt/fstests/SCRATCH_DIR/union/l,upperdir=/mnt/fstests/SCRATCH_DIR/union/7/u,workdir=/mnt/fstests/SCRATCH_DIR/union/7/w
+unionmount testsuite failed! see /var/lib/xfstests/results//overlay/103.full for details.
 Silence is golden

> _require_xfs_io_shutdown()
> {
>                 if [ $FSTYP = "overlay" ]; then
>                         # Overlayfs tests can use _scratch_shutdown, but they
>                         # cannot use "xfs_io -c shutdown"  command
> without jumping
>                         # through hoops, so by default we do not support it.
>                         _notrun "xfs_io -c shutdown not supported on $FSTYP"
>                 fi
>                 _require_xfs_io_command "shutdown"
>                 _require_scratch_shutdown
> }



> 
> Thanks,
> Amir
> 

