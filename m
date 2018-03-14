Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj5GqmMCLpeq0oHacUPeSRu6P7GyiQP=13YBq9C7GgBGQ@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <1521025377.4552.6.camel@kernel.org> <1521037013.40526.8.camel@primarydata.com>
 <1521037854.4552.19.camel@kernel.org> <CAOQ4uxig8aM2WnVQniAXWBOWtnv8ciqqBWXZZgG-foVW04bofQ@mail.gmail.com>
 <1521039981.40526.11.camel@primarydata.com> <CAOQ4uxj5GqmMCLpeq0oHacUPeSRu6P7GyiQP=13YBq9C7GgBGQ@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Wed, 14 Mar 2018 23:40:56 +0800
Message-ID: <CALLuPvpSXg57BORs70fvvANOFKfqeXO5uuorHESj24N8KWEOTQ@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, "jlayton@kernel.org" <jlayton@kernel.org>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

This is an always reproduced case for NFSv3 over overlayfs, and each
dir under nfs mount point behaviors the same. The same overlay
exported mount with NFSv4 returns correct d_type. And for ext4
exported mount with NFSv3 returns correct as well.

My simple test program is like:
void main(int argc, void **argv) {
    DIR *dir = opendir(argv[1]);

    if (dir == NULL) {
        fprintf(stderr,
                "ERROR: Could not open dir: %s\n", argv[1]);
        return;
    }
    struct dirent *ent;
    while ((ent = readdir(dir)) != NULL) {
       printf("readdir: %s ino(%x) type(%x)\n", ent->d_name,
ent->d_ino, ent->d_type);
    }
    closedir(dir);

}

output is:
readdir: . ino(e0003) type(0)
readdir: .. ino(e0003) type(0)
readdir: foo ino(e0007) type(0)

2018-03-14 23:14 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
> On Wed, Mar 14, 2018 at 5:06 PM, Trond Myklebust
> <trondmy@primarydata.com> wrote:
>> On Wed, 2018-03-14 at 17:03 +0200, Amir Goldstein wrote:
>>> On Wed, Mar 14, 2018 at 4:30 PM, Jeff Layton <jlayton@kernel.org>
>>> wrote:
>>> > On Wed, 2018-03-14 at 14:16 +0000, Trond Myklebust wrote:
>>> > > On Wed, 2018-03-14 at 07:02 -0400, Jeff Layton wrote:
>>> > > > On Wed, 2018-03-14 at 16:42 +0800, Eddie Horng wrote:
>>> > > > > Hi Amir,
>>> > > > > Since the flock issue is clarified, I would like to start
>>> > > > > this new
>>> > > > > thread to discuss if we can find the cause of
>>> > > > > d_type=DT_UNKNOWN.
>>> > > > > First
>>> > > >
>>> > > > This sounds like NOTABUG to me. As readdir(3) states:
>>> > > >
>>> > > > Currently, only some filesystems (among them: Btrfs, ext2,
>>> > > > ext3,
>>> > > > and ext4) have full
>>> > > > support  for  returning  the  file  type  in
>>> > > > d_type.   All  applications  must  properly  handle  a return
>>> > > > of
>>> > > > DT_UNKNOWN.
>>> > > >
>>> > > > Applications that rely solely on d_type are effectively broken.
>>> > > > You
>>> > > > always need to be able to follow up with a stat or equivalent.
>>> > > >
>>> > >
>>> > > Yes, but one of the main such applications is the "find" utility,
>>> > > which
>>> > > uses it to avoid calling stat() in order to discover the
>>> > > directories.
>>> > > For that reason, NFS does try to set the d_type flag when it is
>>> > > using
>>> > > readdirplus, and the server returns attributes for the entry in
>>> > > question. Otherwise, it is forced to default to DT_UNKNOWN.
>>> > >
>>> >
>>> > Yes, didn't mean to imply that we shouldn't try to fill these out
>>> > where
>>> > we can, just that there are situations where we might not be able
>>> > to do
>>> > so without taking a performance hit.
>>> >
>>> > > Note that in the cases where the readdir entry has a matching
>>> > > dentry,
>>> > > we probably could try to do better by doing a d_lookup() and then
>>> > > filling the d_type. Is that worth doing?
>>> > >
>>> >
>>> > I like that idea. Filling out what info we can from the local cache
>>> > is
>>> > almost always worthwhile.
>>> >
>>> > An inode's d_type can never change, so you can just vet the fileid
>>> > or fh
>>> > in the entry3 vs. the inode that comes back from d_lookup. If they
>>> > match
>>> > then you can reliably fill that out.
>>> >
>>>
>>> Ironically, this is where NFS over overlayfs may fail, because in
>>> overlayfs
>>> d_ino is not always consistent with st_ino. Since v4.15, d_ino is
>>> consistent
>>> with st_ino for the case of all layers on the same filesystem. I
>>> already posted
>>> a POC for fixing d_ino/st_ino for non-samefs, but it never got
>>> merged.
>>>
>>> What puzzles me w.r.t. this "nonbug" report is that I don't
>>> understand why
>>> NFS over overlayfs would behave differently vs. NFS over local fs.
>>> I am hoping it does not point to a different problem, so would love
>>> to
>>> get a more detailed analysis of what's going on between nfsd and
>>> overlayfs.
>>
>> The behaviour being described is true of the regular NFS client. It has
>> nothing to do with overlayfs.
>>
>
> Here:
> https://marc.info/?l=linux-unionfs&m=152093050204357&w=2
>
> Eddie claims that the observed DT_UNKNOWN issue is reproduced
> with NFSv3 over overlayfs and NOT with NFSv3 over ext4.
>
> That's the only fact I find puzzling.
>
> But I did not see a confirmation that this is a reproducible problem
> with exact same directory and I did not try to reproduce it myself.
>
> Thanks,
> Amir.
