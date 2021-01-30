Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E85C433DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 Jan 2021 02:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63DD764E04
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 Jan 2021 02:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhA3CJD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 21:09:03 -0500
Received: from mail.hallyn.com ([178.63.66.53]:45774 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhA3CHQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Jan 2021 21:07:16 -0500
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 6ADC26B5; Fri, 29 Jan 2021 20:04:51 -0600 (CST)
Date:   Fri, 29 Jan 2021 20:04:51 -0600
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 2/2] security.capability: fix conversions on getxattr
Message-ID: <20210130020451.GA7163@mail.hallyn.com>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
 <20210119162204.2081137-3-mszeredi@redhat.com>
 <8735yw8k7a.fsf@x220.int.ebiederm.org>
 <20210128165852.GA20974@mail.hallyn.com>
 <CAJfpegt34fO8tUw8R2_ZxxKHBdBO_-quf+-f3N8aZmS=1oRdvQ@mail.gmail.com>
 <20210129153807.GA1130@mail.hallyn.com>
 <87h7mzs5hi.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7mzs5hi.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jan 29, 2021 at 05:11:53PM -0600, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > On Thu, Jan 28, 2021 at 08:44:26PM +0100, Miklos Szeredi wrote:
> >> On Thu, Jan 28, 2021 at 6:09 PM Serge E. Hallyn <serge@hallyn.com> wrote:
> >> >
> >> > On Tue, Jan 19, 2021 at 07:34:49PM -0600, Eric W. Biederman wrote:
> >> > > Miklos Szeredi <mszeredi@redhat.com> writes:
> >> > >
> >> > > >     if (!rootid_owns_currentns(kroot)) {
> >> > > > -           kfree(tmpbuf);
> >> > > > -           return -EOPNOTSUPP;
> >> > > > +           size = -EOVERFLOW;
> >> >
> >> > Why this change?  Christian (cc:d) noticed that this is a user visible change.
> >> > Without this change, if you are in a userns which has different rootid, the
> >> > EOVERFLOW tells vfs_getxattr to vall back to __vfs_getxattr() and so you can
> >> > see the v3 capability with its rootid.
> >> >
> >> > With this change, you instead just get EOVERFLOW.
> >> 
> >> Why would the user want to see nonsense (in its own userns) rootid and
> >> what would it do with it?
> >
> > They would know that the data is there.
> 
> But an error of -EOVERFLOW still indicates data is there.
> You just don't get the data because it can not be represented.

Ok - and this happens *after* the check for whether the rootid to maps
into the current ns.

That sounds reasonable, thanks.

> >> Please give an example where an untranslatable rootid would make any
> >> sense at all to the user.
> >
> > I may have accidentally, from init_user_ns, as uid 1000, set an
> > fscap with rootid 100001 instead of 100000, and wonder why the
> > cap is not working in the container where 100000 is root.
> 
> Getting -EOVERFLOW when attempting to read the cap from inside
> the user namespace will immediately tell you what is wrong. The rootid
> does not map.
> 
> That is how all the non-mapping situations are handled.  Either
> -EOVERFLOW or returning INVALID_UID/the unmapped user id aka nobody.
> 
> The existing code is wrong because it returns a completely untranslated
> uid, which is completely non-sense.
> 
> An argument could be made for returning a rootid of 0xffffffff aka
> INVALID_UID in a v3 cap xattr when the rootid can not be mapped.  I
> think that is what we do with posix_acls that contain ids that don't
> map.  My sense is returning -EOVERFLOW inside the container and
> returning the v3 cap xattr outside the container will most quickly get
> the problem diagnosed, and will be the most likely to not cause
> problems.
> 
> If there is a good case for returning a v3 cap with rootid of 0xffffffff
> instead of -EOVERFLOW we can do that.  Right now I don't see anything
> that would be compelling in either direction.
> 
> Eric
> 
> 
> 
