Return-Path: <zohar@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfs: replace i_readcount with a biased i_count
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Wed, 12 Jun 2019 11:59:06 -0400
In-Reply-To: <CAOQ4uxhooVwtHcDCr4hu+ovzKGUdWfQ+3F3nbgK3HXgV+fUK9w@mail.gmail.com>
References: <20190608135717.8472-1-amir73il@gmail.com>
	 <20190608135717.8472-2-amir73il@gmail.com>
	 <1560343899.4578.9.camel@linux.ibm.com>
	 <CAOQ4uxhooVwtHcDCr4hu+ovzKGUdWfQ+3F3nbgK3HXgV+fUK9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1560355146.4578.61.camel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, 2019-06-12 at 18:09 +0300, Amir Goldstein wrote:
> On Wed, Jun 12, 2019 at 3:52 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > On Sat, 2019-06-08 at 16:57 +0300, Amir Goldstein wrote:
> > > Count struct files open RO together with inode reference count instead
> > > of using a dedicated i_readcount field.  This will allow us to use the
> > > RO count also when CONFIG_IMA is not defined and will reduce the size of
> > > struct inode for 32bit archs when CONFIG_IMA is defined.
> > >
> > > We need this RO count for posix leases code, which currently naively
> > > checks i_count and d_count in an inaccurate manner.
> > >
> > > Should regular i_count overflow into RO count bias by struct files
> > > opened for write, it's not a big deal, as we mostly need the RO count
> > > to be reliable when the first writer comes along.
> >
> > "i_count" has been defined forever.  Has its meaning changed?  This
> > patch implies that "i_readcount" was never really needed.
> >
> 
> Not really.
> i_count is only used to know if object is referenced.
> It does not matter if user takes 1 or more references on i_count
> as long as user puts back all the references it took.
> 
> If user took i_readcount, i_count cannot be zero, so short of overflow,
> we can describe i_readcount as a biased i_count.

Having a count was originally to make sure we weren't missing
anything.  As long as we can detect if a file is opened for read, the
less IMA specific code there is, the better.

> 
> But if I am following Miklos' suggestion to make i_count 64bit, inode
> struct size is going to grow for 32bit arch when  CONFIG_IMA is not
> defined, so to reduce impact, I will keep i_readcount as a separate
> member and let it be defined also when BITS_PER_LONG == 64
> and implement inode_is_open_rdonly() using d_count and i_count
> when i_readcount is not defined.
> 
> Let's see what people will have to say about that...

Ok

Mimi
