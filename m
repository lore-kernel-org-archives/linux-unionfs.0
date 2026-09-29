Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFAA51D530
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 12:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683975; cv=none; b=nRQX2s8/zjjtVkr/GCANgJ68uasjZm4lktd/NAOGosOUbYTwdiuiCPuGx/xywhR5hgIV7cPzSgAeI601EEWUpG6kxw6nJKaWBAIUfZlUPvKcF94S+NkN9l5DHXG21sBRKCH/9O/TqZD9YR/9dJVu5Ph9GbJx29uZOD9GImriq/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683975; c=relaxed/simple;
	bh=aOHR2S9JoDTNHa4EinckRR5sM8LP9tsgVirzxTuKr0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJRgsyTCwW5RP0sF5MhNVGHcAR+CldKPy9OVHfCH5kKsYtT3untQD/UMj54O8TsvMRrN5HoF2ccYhuw+hn/AYjwxZbF0E5gBZHXw/zLlyZl9exe1NsZwDWLE6yDGqdcOmy14c3bxj5gn9dvo4aqk+zqDIcWFxmmRig3aCOMR1As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QyEG82Sm; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QyEG82Sm"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912df756so32428985e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Sep 2026 05:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790683970; x=1791288770; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=paQ2/onKT319WLEUhupq6lCWp4YbjzVGMuOnFcHWo94=;
        b=QyEG82SmuQbhxv/tvt8fWEEJyBx3C/J67V1ppnGriDCnECzwj7IiLhhzdcgcBxymrj
         kS9Pe6wkinSaUtJwWQtEOU6MUkf9yk/l80tHOztmTsC9qzublESDlQ6H2Hl2vHAxcwEW
         c84NBPFYN5ZkQmX5Bk7yHpMVlu5WfN98cI7tRIrh4Wfenc0HHl3so+tRXnYHK36oCVoN
         QLbEnJGJs58Nrq2elz35x/N6B92ykl2YmbFpPzQAgfaoag0Tyv207hHGY9+w0FnJqvxQ
         u4FeNQ+fwqN0HF3KfGxiicb3NAtmej3V/zUBvciwLUInq5y+YV0oXc2dtc00TH9svvpX
         nz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790683970; x=1791288770;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=paQ2/onKT319WLEUhupq6lCWp4YbjzVGMuOnFcHWo94=;
        b=Abl0IMDqFM+q7UzrgmMxADXatOhlYmkLzACYPNQDCftkd9xPPugHHB/U+2ihP/ID+/
         ccSvzvDWtJ2Yn2lppSyGXZAU6las2dmwS8V/TTKGsC9r4Kc7daRyq7ktq6Q0eeExZ+Yy
         2xsX/IyCiKB2CZeRGsK8BSAciCJGooA2zfZP/pCZeSHYIL9PRMrENUMooDQd5VZN6qEp
         M1Z6v/wxK2DClzYg8Ju4m7wxjsZRgEX7hq1q7FzbdSyqiJEJsnQxW5cDGDgNk98ypj+7
         G4rFKQyiWNjrjNrxAG9jnrei2EhU2SPtu9TKFR4204nHrV1h4YQMGmjFDaDK9u/qGWma
         whJA==
X-Forwarded-Encrypted: i=1; AKwUvBy87eulQT9AGXRPY8bHHjcozqAagEaZfv1zpCW7HDpWda4qaEkc2rnJtPSs5eH8Mz+m7hEDH3WCvBU1n50q@vger.kernel.org
X-Gm-Message-State: AFuF++nEV/g1VPwyU/rldtflOTg4rXPIp+6jNQoEdOpj669t0zYnWaG9
	I601ajx6hgNSsac0YQafPQy9cJa+8D4ShMp3XkE6IDtlgBEn4K4k3fQ6jrRbjWo1Ew==
X-Gm-Gg: AYBFou0jnbrQie59SqkLOgQ1k20ZuMrFmojt006NeERID4DFaX3KdBScv9c0eAv3vmy
	yNKkjifa7wsunLZGKxwL7T7JYMyhkhhWFqnmhc5ReNM5ah/6zJiDWoWWdOFb+A4Bvgl8/jYmC9F
	MthDW164z+APTX9e2nXCFbH+YLHtKqx/ttRH8xuM6K2nnU9z8LYl2qVJks7BVUGR/WTdWQCRnEY
	OfQwaRDddP/03TQU1WGuo0YEwrHSLXBe6uiWGEGC4fbPKSUbX9a6wmTEQQbiFPxBzTsF8YPAtWR
	/9jTxFuk12Q4PQqPUDQmlhdE8j1YdVHDXlFXCSK++M8XWCr95zpP1UgOSr1AnCpD/vUzKOrE0v4
	2a7KOfyisi3lukoEdZyFtLMacvCnhcSG0Y5gRjSBOJnXTx8jLFCHtEz+LKNyRyjRFbUZen3xWdA
	CyiOdWJcr6lcRTAcKENexv9Esjb0RFBkJwYf1OM18K9xi0pvFms5KVH5iukl4ETbKxYJbw8DZE1
	n+a5Hata5WFWXAek2hWQKSqW7V00Q==
X-Received: by 2002:a05:600c:1d28:b0:49c:fc6e:8cbd with SMTP id 5b1f17b1804b1-49fe66fc677mr302281505e9.33.1790683968737;
        Tue, 29 Sep 2026 05:12:48 -0700 (PDT)
Received: from google.com ([2a00:79e0:288a:8:ce20:1d4f:298a:2070])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013b8f6f5sm4087715e9.10.2026.09.29.05.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 05:12:48 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:12:42 +0200
From: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>
To: Justin Suess <utilityemal77@gmail.com>
Cc: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack3000@gmail.com>,
	Cai Xinchen <caixinchen1@huawei.com>, mic@digikod.net,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dlemoal@kernel.org, hch@lst.de, axboe@kernel.dk,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	dhowells@redhat.com, code@tyhicks.com, linkinjeon@kernel.org,
	sj1557.seo@samsung.com, yuezhang.mo@sony.com,
	hirofumi@mail.parknet.co.jp, cel@kernel.org, jlayton@kernel.org,
	neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com,
	tom@talpey.com, miklos@szeredi.hu, amir73il@gmail.com,
	senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	stephen.smalley.work@gmail.com, omosnacek@gmail.com,
	casey@schaufler-ca.com, nanx95726@gmail.com, djwong@kernel.org,
	daniel@iogearbox.net, linux-security-module@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
	ecryptfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-integrity@vger.kernel.org,
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
	xiujianfeng@huawei.com, lujialin4@huawei.com
Subject: Re: [PATCH RFC -next 00/12] landlock: Add READ_METADATA and
 WRITE_METADATA access rights
Message-ID: <arurOphe6QIx2Zr8@google.com>
References: <20260924104831.1081137-1-caixinchen1@huawei.com>
 <araxO4ze0KZBz756@suesslenovo>
 <20260926.255b951d3013@gnoack.org>
 <arqcbjWLN1CLkL_Y@suesslenovo>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arqcbjWLN1CLkL_Y@suesslenovo>

On Mon, Sep 28, 2026 at 01:13:35PM -0400, Justin Suess wrote:
> On Sat, Sep 26, 2026 at 09:56:28AM +0200, Günther Noack wrote:
> > Hello!
> > 
> > On Fri, Sep 25, 2026 at 02:03:05PM -0400, Justin Suess wrote:
> > > On Thu, Sep 24, 2026 at 06:48:19PM +0800, Cai Xinchen wrote:
> > > > This series adds two new Landlock filesystem access rights,
> > > > LANDLOCK_ACCESS_FS_READ_METADATA and LANDLOCK_ACCESS_FS_WRITE_METADATA,
> > > > which control access to file and directory metadata such as inode
> > > > attributes (mode, ownership, timestamps), extended attributes and POSIX
> > > > ACLs.  It picks up the work from the "landlock: add chmod and chown
> > > > support" series [1] and follows the coarse-grained grouping discussed in
> > > > that thread [2]: instead of separate chmod/chown rights, metadata
> > > > operations are grouped into one read and one write right.
> > > > 
> > > > Landlock evaluates access rights on a per-path basis, but the metadata
> > > > related LSM hooks (inode_getattr, inode_setattr, inode_setxattr,
> > > > inode_getxattr, inode_listxattr, inode_removexattr, inode_set_acl,
> > > > inode_get_acl, inode_remove_acl) only receive the dentry of the accessed
> > > > object.  Patches 1-7 therefore first pass struct path instead of dentry
> > > > through the metadata-related VFS helpers and LSM hooks.  This is a pure
> > > > refactoring with no behavior change, split so that every patch builds
> > > > and works on its own:
> > > >
> > > I like these patches, but is the ability to read metadata already
> > > sorta controlled by LANDLOCK_ACCESS_FS_READ_DIR on the parent
> > > directory?
> > > 
> > > The one case I see this being different is:
> > > 
> > > 1. if you wanted to grant read access to the file, but not metadata
> > > read access, but I can't think of any usecase for being able to read
> > > the contents of a file, but not the metadata. (see below)
> > > 
> > > 2. If you had the absolute path already and didn't need READ_DIR.
> > > 
> > > I see introducing this READ_METADATA as causing potential
> > > hard-to-diagnose issues.
> > > 
> > > Say you handle READ_METADATA and READ_FILE, but only grant READ_FILE.
> > > 
> > > The program can technically open the file with the READ_FILE permission,
> > > but it may error out because the stat() on it beforehand failed.
> > > It's pretty common for programs to do that kind of thing (stat before
> > > open), like for checking for config files (strace bash and you see it
> > > stat .profile, /etc/profile)
> > > 
> > > There may be other bugs, because being able to set permissions to read
> > > a file *but not read it's metadata* isn't possible currently in posix
> > > acl and userspace may not work well if that assumption no longer holds.
> > >
> * posix acl and linux DAC.
> 
> > > So maybe WRITE_METADATA is good enough?
> > 
> > The existing use cases are the combinations of (a) READ_DIR
> > allowed/denied and (b) READ_METADATA allowed/denied.  Because these
> > two access rights overlap slightly, it seems likely that for a given
> > directory or file, users will want to either grant both, or deny both.
> > 
> > At the moment, where the (not yet existing) READ_METADATA is
> > implicitly always allowed, the problematic case is the one where the
> > Landlock user wants to deny READ_DIR, but where much of the same
> > metadata is still available through stat() and the various
> > get-attribute syscalls.  (c.f. the warning box in the Landlock docs
> > [1])
> > 
> > In my view the READ_METADATA right closes a gap that READ_DIR left
> > open (which is also potentially surprising to callers if they did not
> > read the docs closely).  Also, if its implementation is symmetric to
> > WRITE_METADATA, I feel that it's worth having it in the same patch
> > set.
> > 
> > –Günther
> > 
> > P.S.: I know, even after we can control stat(), there are likely ways
> > to infer the presence of a file by observing Landlock error codes.
> > This would be nice to fix as well, but is harder to do without
> > controlling the path walk itself [2].  But also, the fact that this is
> > currently not controllable is not an excuse for leaving READ_METADATA
> > open IMHO.
> >
> I'm still sort of concerned about the case where read access is allowed,
> but metadata isn't, due to how many applications will not cleanly handle
> such an unexpected condition. You can reproduce this with a seccomp
> policy forbidding stat().
> 
> Would it make sense to have the existing READ rights
> (READ_DIR/READ_FILE) imply READ_METADATA on the files/directories 
> if READ_METADATA is handled? Reading a file's contents should always
> imply that you can read the metadata.

I am wary of situations where the handling of access rights implicity
implies other access rights.  We have discussed such schemes in the
past (e.g. we considered a design for RESOLVE_UNIX where we'd have
both a "scoped" and a "access_fs" right that would interact with each
other), but in the end we always settled for approaches where such
interactions would not be necessary.  One of the concerns was that it
would complicate "best effort" fallback logic in all Landlock
libraries and in the countless places where people use the syscalls
directly.

To throw another option in the mix.  (To be clear, I have only 70%
confidence, so feel free to push back, but it feels like it might
work?):

Is this similar to the "truncate" right?
----------------------------------------

With "truncate", there was an existing common operation (open(2) with
O_TRUNC, a.k.a. creat(2)) which called the truncation hook and checked
for the truncation access right.  But that was in fact OK.  The way we
resolved it at the time was by documenting very loudly that WRITE_FILE
and TRUNCATE access rights should always be requested in lockstep, if
TRUNCATE is handled.

If READ_DIR and READ_FILE do in fact read and return metadata to the
user, maybe the right thing would be to do it the same way here and
*require* that we have READ_METADATA to do these operations?

(READ_METADATA is automatically allowed as long as it's not handled,
so that approach does not break existing programs.  Programs who
consciously start handling READ_METADATA must simply take into account
that reading directories and opening files for reading requires
READ_METADATA.)

(BTW, I can see it for reading directories, but I am not sure I fully
follow the argument why opening files for reading means that you can
read the metadata?  Can't that be guarded on fstat()-like operations?)

—Günther
