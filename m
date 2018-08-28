From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 3/3] overlayfs: override_creds=off option bypass creator_cred
Date: Wed, 29 Aug 2018 00:20:06 +0300
Message-ID: <CAOQ4uxg5chFxo5wM-qtBYW0TPcsemtdh4WdRrtJDW_VvsAbtAQ@mail.gmail.com>
References: <20180828165336.211643-1-salyzyn@android.com> <a8dc66c4-4761-4876-abd3-6dc135692404@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a8dc66c4-4761-4876-abd3-6dc135692404@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Salyzyn <salyzyn@android.com>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Aug 28, 2018 at 9:09 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 08/28/2018 09:53 AM, Mark Salyzyn wrote:
> > diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> > index 72615a2c0752..953e52971eb0 100644
> > --- a/Documentation/filesystems/overlayfs.txt
> > +++ b/Documentation/filesystems/overlayfs.txt
> > @@ -106,6 +106,35 @@ Only the lists of names from directories are merged.  Other content
> >  such as metadata and extended attributes are reported for the upper
> >  directory only.  These attributes of the lower directory are hidden.
> >
> > +credentials
> > +-----------
> > +
> > +By default, all access to the upper, lower and work directories is the
> > +recorded mounter's MAC and DAC credentials.  The incoming accesses are
> > +checked against the caller's credentials.
> > +
> > +If the principles of least privilege are applied, the mounter's
> > +credentials might not overlap the credentials of the caller's when
> > +accessing the overlayfs filesystem.  For example, a file that a lower
> > +DAC privileged caller can execute, but is MAC denied to the
> > +generally higher DAC privileged mounter, to prevent an attack vector
> > +executing with the increased privileges of the mounter.  One option is
> > +to turn off override_creds in the mount options; all subsequent
> > +operations after mount on the filesystem will be only the caller's
> > +credentials.  This option default is set in the CONFIG
> > +OVERLAY_FS_OVERRIDE_CREDS or in the module option override_creds.
> > +Fundamentally The mounter has privileges, its ability to execute,
>
>                  the
>
> but this entire sentence is jumbled and awkward and could use some work.
> I tried to come up with something but I can't quite get what is intended here.
>

I have a very similar feeling - I do not feel any more knowledgeable after
reading the above.
My 2 cents - don't try to explain your reasoning for using this feature
the use case is too awkward. You may need to rationalize your use
case to get the feature merged, but spare the poor user who reads the
manual.
Explaining what  override_creds=off does is simple - stick to that
with a disclaimer about things that may not work well.

>
> > +for example, files and grant them these higher privileges is to be
> > +blocked except to lower privileged and appropriate callers.  This
> > +option turned off permits this kind of security policy.
> > +
> > +With override_creds turned off, several unintended side effects will
> > +occur.  The caller with a lower privilege will not be able to delete
> > +files or directories, create nodes, or search some directories.  The
> > +uneven security model where upperdir and workdir are opened at
> > +privilege, but accessed without, should only be used with strict
> > +understanding of the side effects and of the security policies.
> > +

I like the ending ;-)
Let's go with "The user may not be able to delete..."

Thanks,
Amir.
