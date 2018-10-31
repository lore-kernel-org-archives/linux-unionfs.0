Return-Path: <vgoyal@redhat.com>
Date: Wed, 31 Oct 2018 11:39:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be
 enabled
Message-ID: <20181031153944.GC20169@redhat.com>
References: <20181031111038.20570-1-amir73il@gmail.com>
 <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com>
 <20181031134723.GA20169@redhat.com>
 <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
 <20181031141752.GB20169@redhat.com>
 <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 05:31:33PM +0200, Amir Goldstein wrote:
> On Wed, Oct 31, 2018 at 4:17 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Oct 31, 2018 at 04:05:02PM +0200, Amir Goldstein wrote:
> > > On Wed, Oct 31, 2018 at 3:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > ...
> > > >
> > > > So "strict" will change behavior. That is where we think configuration
> > > > is not right/suboptimal, we will fail mount?
> > > >
> > > > I feel little odd about enabling "strict" implicitly just because
> > > > "metacopy" has been passed in. To me, for all new mount options,
> > > > "strict" should be default implementation (and does not require
> > > > strict to be on as such).
> > > >
> > > > For old options, users are already happy with what they are seeing
> > > > as of now. Those who want strict behavior, they should pass in
> > > > "strict=on" and then behavior of old knobs will change without
> > > > breaking backward compatibility.
> > > >
> > >
> > > We need to think of users and documentation and real life use cases.
> > > We need to think of overlayfs code maintenance and overlayfs developers.
> > > We need to come up with a compromise that is the best of all worlds.
> > >
> > > Maintaining different behavior per feature complicates the code and
> > > IMO brings no real value to users.
> > >
> > > If you think there is a concrete real world problem with metacopy=on
> > > implying strict=on, please present the case.
> > >
> > > Are you interested in making metacopy=on work on sub-optimal upper
> > > file systems? Which one?
> > > Are you interested in making index=on,metacopy=on fallback to
> > > index=off,metacopy=on on underlying fs without file handle support?
> > > Why?
> > > What is the real life use case for which you wish to preserve those
> > > behaviors that are mostly there because we made mistakes in the
> > > past?
> >
> > I don't have a good example. But, following is my thought process that
> > why I think turning on strict with metacopy=on is not very good.
> >
> > - Turning on strict on, can make a working configuration fail due to
> >   unrelated reasons. Say d_type is not supported and user is fine with
> >   that and wants metacopy=on. Now that will not work and it will be
> >   confusing to understand that what metacopy has to do with d_type.
> >
> 
> It is not in the best of our (overlayfs developers) interest to allow users
> to shoot their own feet. We allow that when we have no choice (backward
> compat), but we really have no reason to do that with new features.
> In fact, new features is our *only* opportunity to deprecate old code
> that is sub-optimal and only exists because of backward compat reasons.
> 
> To use a very concrete example, index=on enables the exclusive upperdir
> workdir checks. Not because index=on needs exclusive upperdir/workdir
> more than index=off, but just because we can. And now docker cannot deal
> with exclusive upperdir/workdir because docker has mount leak bugs, so
> docker sets index=off to workaround its own bugs.
> 
> If ever docker would want to provide sane hardlink behavior to its users,
> docker will have to fix its mount leaks bugs first. We keep looking backwards,
> but general direction should be forward!
> 

Ok. So basically strict and metacopy has no connection but we want to
take this opportunity to enable more sane overlayfs behavior by default
without breaking backward compatibility.

And if a corner case user does not like implicit strict=on, they can
specifically do "metacopy=on,strict=off".

I am fine with this. Thanks.

So every new mount option now will enable strict=on implicitly?

Thanks
Vivek
