Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C15286D6B
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Jun 2025 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749205762; cv=none; b=uyE8MXjDG1HE3bSna9KuDUmApj+2sjD0WTwp4LCoaIGP9ytDkd4Ip5WSQYCnIO9//U3nkECD76ntKgyQ/EKQdXs9Fiieh8dKCA9k2eimdf/NScMviGMlj9wRMa30/T4j9zMya28AU6XIqBQaRp4Jx9fA7SuCmyqqjvz6ci9lQ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749205762; c=relaxed/simple;
	bh=ovb5PQxNVmSF9BymKxv3zhlOSanlzI4E7tL7cXER86g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJNdB13A9j6tcLzkiNEMz/U6PKyCeiQQ2BCxmjAXbC8gPvks3rzeqUOc7VFObHE0iXAkJunWTHtInPcHHmZBJR091kgoxJftOCkrj+s9lRP9QMRyxtIe6fdnFX5NMMKCygCGzP5lT4GPU4sUzJgSWqG3ywotKP2F189pYZbLjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GsXcQCrB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GsXcQCrB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749205757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ouuG2sVrNpRvVEt4qeaFF0ptkcl/5vw4YEotrMQiwmo=;
	b=GsXcQCrBeVRet46horhUYKzv7IQrlvrDRsFb5BVUQu2gPesgsy460SfE5uIdlkLsbzHoyQ
	8hPmZkGX6EH6HFjTtZmA9SwO24cHFXtvGcfnyQlU8Ek3cac7t+U2VDk27b4a4gl9++WMT/
	0ZoCMwXrQQHH6Qg6lj2ECnm+ruICAfk=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-fZtIVdQRO9umscAGU8-2yQ-1; Fri, 06 Jun 2025 06:29:16 -0400
X-MC-Unique: fZtIVdQRO9umscAGU8-2yQ-1
X-Mimecast-MFC-AGG-ID: fZtIVdQRO9umscAGU8-2yQ_1749205755
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-740774348f6so1859456b3a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Jun 2025 03:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749205755; x=1749810555;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouuG2sVrNpRvVEt4qeaFF0ptkcl/5vw4YEotrMQiwmo=;
        b=LcumfoMFQN0Gw57Qj9Ri1WkVtEi1wlbyBSNsosqQA6u2bQiWO44A0cqOC/RNsr6EN/
         ajE8jchHcthQf0uObDEdqFmxGmiFNzqnuTj4NxJJBJa2101+6KLzC6G//6ZLDfdXavgh
         Y6/gH+INE0cjh5MJvKU+s3SSS+4QUj6uYrVBoKm9z3ZheMKHiG3nWAFReCVgvQ2zpnwt
         ciK1WXpRRxgg//bI+yMxt6LsanSOwBj+bMwDeB06rJi/pKejr7nKCAClqsjuzsNBn/6+
         rQScjwP3Lv14ai54Q5sub1udQOo1AXW2FR/OGrx2Hq1zNJz1eRaVA2NdaKx8cCbyv1Du
         GKSw==
X-Forwarded-Encrypted: i=1; AJvYcCVMNhM9qofogQMVxlgQWvdoQPYulQ9g9J0YEdX+OmtisILDwVIF4i9l/sXA6soaBEPssqGMRqG1hN/Kmohc@vger.kernel.org
X-Gm-Message-State: AOJu0Yx72XLIqjDJkxmcc13+TakQ/veot9lo0CghCbTSvZx44Qh23uw3
	Ilv/F4rv8IGauCsgcU9veEJvOxbYT7z0hqBQFkiRw75lhZ0ZCOSS37uTanPMJ5o/lTZ4jaHwNU9
	3QxOZkcptN76lGhPFxwymQMrasM7u7D3bRXgacBj7IqWx6FzbdYxuSr5Ai3utH34sd2k=
X-Gm-Gg: ASbGncukMYRtHa2WIYxAT5ygKb/B3PKg6YppJxgIyiWeOovXaasCpgyGcQEM6cVXOD/
	CDogQDDXVNjeP88OZBrwyNFfSfgdorcahEKhO5mdJspx3BZcShdGHcU6ULDNgnp5i95R+G+PjM1
	+zJ3MI0dgYBKOBuMP9g0OVrYZBOgZpTWQYJNlMae4Gg4+7opciqxbqCG8Czu1+9qIt7PaXNrEc2
	IwNwGy2YMPnUo6JUOizBBLqW26xPcBXd5krxLghQtwLNZ1R0h8VWxwNG3a3k92JW9M13KvopcLy
	7c60Ga9+SHQUL3TKJwDDbhRQrRDC2BK1GbW+zeEz1UpmboueuOLb
X-Received: by 2002:a05:6a00:2d28:b0:740:6f69:8d94 with SMTP id d2e1a72fcca58-74827cffd46mr4824823b3a.0.1749205755135;
        Fri, 06 Jun 2025 03:29:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4yubNjKg+BRqDbgk6jvpzFCyb0eCbkk54CwQ/z2QSSw/ObS3yBSx+l/s3BDt5bBXGPoWLRw==
X-Received: by 2002:a05:6a00:2d28:b0:740:6f69:8d94 with SMTP id d2e1a72fcca58-74827cffd46mr4824799b3a.0.1749205754733;
        Fri, 06 Jun 2025 03:29:14 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0eb0f1sm977325b3a.169.2025.06.06.03.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 03:29:14 -0700 (PDT)
Date: Fri, 6 Jun 2025 18:29:09 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
Message-ID: <20250606102909.77jj6txkqii7erpn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-5-amir73il@gmail.com>
 <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgQi6ciXtoKV7Nrw5_ECBOwS_m8h2KXT-ieJ4x4t04qag@mail.gmail.com>
 <20250606014531.d5t4gwx4iymqiqlo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxj_rshiLUUrCVS6RO+KhCeLrrgxNH+me3K38Nhc0Byqzw@mail.gmail.com>

On Fri, Jun 06, 2025 at 09:23:26AM +0200, Amir Goldstein wrote:
> On Fri, Jun 6, 2025 at 3:45 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Thu, Jun 05, 2025 at 08:38:30PM +0200, Amir Goldstein wrote:
> > > On Thu, Jun 5, 2025 at 7:32 PM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> > > > > This test performs shutdown via xfs_io -c shutdown.
> > > > >
> > > > > Overlayfs tests can use _scratch_shutdown, but they cannot use
> > > > > "-c shutdown" xfs_io command without jumping through hoops, so by
> > > > > default we do not support it.
> > > > >
> > > > > Add this condition to _require_xfs_io_command and add the require
> > > > > statement to test generic/623 so it wont run with overlayfs.
> > > > >
> > > > > Reported-by: André Almeida <andrealmeid@igalia.com>
> > > > > Tested-by: André Almeida <andrealmeid@igalia.com>
> > > > > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >  common/rc         | 8 ++++++++
> > > > >  tests/generic/623 | 1 +
> > > > >  2 files changed, 9 insertions(+)
> > > > >
> > > > > diff --git a/common/rc b/common/rc
> > > > > index d8ee8328..bffd576a 100644
> > > > > --- a/common/rc
> > > > > +++ b/common/rc
> > > > > @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
> > > > >               touch $testfile
> > > > >               testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> > > > >               ;;
> > > > > +     "shutdown")
> > > > > +             if [ $FSTYP = "overlay" ]; then
> > > > > +                     # Overlayfs tests can use _scratch_shutdown, but they
> > > > > +                     # cannot use "-c shutdown" xfs_io command without jumping
> > > > > +                     # through hoops, so by default we do not support it.
> > > > > +                     _notrun "xfs_io $command not supported on $FSTYP"
> > > > > +             fi
> > > > > +             ;;
> > > >
> > > > Hmm... I'm not sure this's a good way.
> > > > For example, overlay/087 does xfs_io shutdown too,
> > >
> > > Yes it does but look at the effort needed to do that properly:
> > >
> > > $XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f
> > > ' -c close -c syncfs $SCRATCH_MNT | \
> > >         grep -vF '[00'
> > >
> > > > generally it should calls
> > > > _require_xfs_io_command "shutdown" although it doesn't. If someone overlay
> > > > test case hope to test as o/087 does, and it calls _require_xfs_io_command "shutdown",
> > > > then it'll be _notrun.
> > >
> > > If someone knows enough to perform the dance above with _scratch_shutdown_handle
> > > then that someone should know enough not to call
> > > _require_xfs_io_command "shutdown".
> > > OTOH, if someone doesn't know then default is to not run.
> >
> > Sure, I can understand that, just this logic is a bit *obscure* :) It sounds like:
> > "If an overlay test case wants to do xfs_io shutdown, it shouldn't call
> > _require_xfs_io_command "shutdown". Or call that to skip a shutdown test
> > on overlay :)"
> >
> > And the expected result of _require_xfs_io_command "shutdown" will be totally
> > opposite with _require_scratch_shutdown on overlay, that might be confused.
> > Can we have a clearer way to deal with that?
> >
> 
> I don't really understand the confusion.
> 
> _require_xfs_io_command "shutdown"
> 
> Like any other _require statement
> requires support for what this test does -
> meaning that a test does xfs_io -c shutdown, just like test generic/623 does
> 
> and _require_scratch_shutdown implies that the test does
> _scratch_shutdown
> 
> FSTYP overlay happens to be able to do _scratch_shutdown
> but not able to do xfs_io -c shutdown $SCRATCH_MNT
> 
> The different _require statements simply reflect reality as it is.
> 
> We can solve the confused about o/087 not having
> _require_xfs_io_command "shutdown"
> by moving the special hand crafted xfs_io command in o/087
> to a helper _scratch_shutdown_and_syncfs to hide those internal
> implementation details from test writers.
> See attached patch.

Hmm... give me a moment to order my thoughts step by step :)

There're only 2 cases tend to do xfs_io shutdown on overlay currently
(others are xfs specific test cases):

  $ grep -rsn shutdown tests/|grep -- "-c"
  tests/generic/623:29:$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
  tests/overlay/087:50:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
  tests/overlay/087:57:$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
  ...

others shutdown cases nearly all use *_scratch_shutdown* with
*_require_scratch_shutdown*, these two functions are consistent in
code logic. And no one calls "_require_xfs_io_command shutdown" currently.

So g/623 and o/087 are specifal, actually they call _require_scratch_shutdown
too, that makes sense for o/087. Now only g/623 doesn't make sense. Now we
need to help it to make sense.

I think the key is in _require_scratch_shutdown function [1], how about add an
argument to clearly tell it we need to check shutdown "only on the top layer
$SCRATCH_MNT" or "try the lowest layer $BASE_SCRATCH_MNT if there is".

For example:

diff --git a/common/rc b/common/rc
index c3af8485c..5f30143e4 100644
--- a/common/rc
+++ b/common/rc
@@ -4075,15 +4075,17 @@ _require_exportfs()
        _require_open_by_handle
 }
 
-# Does shutdown work on this fs?
+# Does shutdown work on this [lower|top] layer fs?
 _require_scratch_shutdown()
 {
+       local layer="${1:-lower}"
+
        [ -x $here/src/godown ] || _notrun "src/godown executable not found"
 
        _scratch_mkfs > /dev/null 2>&1 || _notrun "_scratch_mkfs failed on $SCRATCH_DEV"
        _scratch_mount
 
-       if [ $FSTYP = "overlay" ]; then
+       if [ $FSTYP = "overlay" -a "$level" = "lower" ]; then
                if [ -z $OVL_BASE_SCRATCH_DEV ]; then
                        # In lagacy overlay usage, it may specify directory as
                        # SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
diff --git a/tests/generic/623 b/tests/generic/623
index b97e2adbe..af0f55397 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -15,7 +15,7 @@ _begin_fstest auto quick shutdown mmap
        "xfs: restore shutdown check in mapped write fault path"
 
 _require_scratch_nocheck
-_require_scratch_shutdown
+_require_scratch_shutdown top
 
 _scratch_mkfs &>> $seqres.full
 _scratch_mount


Thanks,
Zorro

[1]
_require_scratch_shutdown()
{
        [ -x $here/src/godown ] || _notrun "src/godown executable not found"

        _scratch_mkfs > /dev/null 2>&1 || _notrun "_scratch_mkfs failed on $SCRATCH_DEV"
        _scratch_mount

        if [ $FSTYP = "overlay" ]; then
                if [ -z $OVL_BASE_SCRATCH_DEV ]; then
                        # In lagacy overlay usage, it may specify directory as
                        # SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
                        # will be null, so check OVL_BASE_SCRATCH_DEV before
                        # running shutdown to avoid shutting down base fs accidently.
                        _notrun "This test requires a valid $OVL_BASE_SCRATCH_DEV as ovl base fs"
                else
                        $here/src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
                        || _notrun "Underlying filesystem does not support shutdown"
                fi
        else
                $here/src/godown -f $SCRATCH_MNT 2>&1 \
                        || _notrun "$FSTYP does not support shutdown"
        fi

        _scratch_unmount
}


> 
> Thanks,
> Amir.


